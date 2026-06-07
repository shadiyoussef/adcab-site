import AppKit
import CoreGraphics

// args: input output cropX cropY cropW cropH [padSquareMarginPx] [outSize]
// crop coords use TOP-LEFT origin in source pixels.
let a = CommandLine.arguments
guard a.count >= 7 else { fputs("usage: crop in out x y w h [margin] [outSize]\n", stderr); exit(1) }
let inPath = a[1], outPath = a[2]
let cx = Double(a[3])!, cy = Double(a[4])!, cw = Double(a[5])!, ch = Double(a[6])!
let margin = a.count > 7 ? Double(a[7])! : 0
let outSize = a.count > 8 ? Int(a[8])! : 0

guard let img = NSImage(contentsOfFile: inPath),
      let src = img.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
  fputs("cannot load \(inPath)\n", stderr); exit(1)
}
let H = Double(src.height)
// CG origin bottom-left: flip y
let cropRect = CGRect(x: cx, y: H - cy - ch, width: cw, height: ch)
guard let cropped = src.cropping(to: cropRect) else { fputs("crop failed\n", stderr); exit(1) }

// square canvas side
let side = max(cw, ch) + 2*margin
let outPx = outSize > 0 ? outSize : Int(side)
let cs = CGColorSpaceCreateDeviceRGB()
guard let ctx = CGContext(data: nil, width: outPx, height: outPx, bitsPerComponent: 8,
                          bytesPerRow: 0, space: cs,
                          bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { exit(1) }
ctx.interpolationQuality = .high
ctx.clear(CGRect(x: 0, y: 0, width: outPx, height: outPx))
let scale = Double(outPx) / side
let drawW = cw * scale, drawH = ch * scale
let ox = (Double(outPx) - drawW)/2, oy = (Double(outPx) - drawH)/2
ctx.draw(cropped, in: CGRect(x: ox, y: oy, width: drawW, height: drawH))
guard let out = ctx.makeImage() else { exit(1) }
let rep = NSBitmapImageRep(cgImage: out)
guard let data = rep.representation(using: .png, properties: [:]) else { exit(1) }
try! data.write(to: URL(fileURLWithPath: outPath))
print("wrote \(outPath) \(outPx)x\(outPx)")
