import AppKit
import CoreGraphics
// args: input output outSize cropX cropY cropW cropH bgHex(or "none") contentFraction
let a = CommandLine.arguments
let inPath=a[1], outPath=a[2]
let outSize=Int(a[3])!
let cx=Double(a[4])!, cy=Double(a[5])!, cw=Double(a[6])!, ch=Double(a[7])!
let bg=a[8]
let frac=Double(a[9])!
guard let img=NSImage(contentsOfFile:inPath), let src=img.cgImage(forProposedRect:nil,context:nil,hints:nil) else { exit(1) }
let H=Double(src.height)
let crop=src.cropping(to: CGRect(x:cx, y:H-cy-ch, width:cw, height:ch))!
let cs=CGColorSpaceCreateDeviceRGB()
let ctx=CGContext(data:nil,width:outSize,height:outSize,bitsPerComponent:8,bytesPerRow:0,space:cs,bitmapInfo:CGImageAlphaInfo.premultipliedLast.rawValue)!
ctx.interpolationQuality = .high
ctx.clear(CGRect(x:0,y:0,width:outSize,height:outSize))
if bg != "none" {
  func h2(_ s:Substring)->CGFloat { CGFloat(Int(s,radix:16)!)/255.0 }
  let r=h2(bg.prefix(2)), g=h2(bg.dropFirst(2).prefix(2)), b=h2(bg.dropFirst(4).prefix(2))
  ctx.setFillColor(CGColor(red:r,green:g,blue:b,alpha:1))
  // rounded tile
  let rad=CGFloat(outSize)*0.18
  let path=CGPath(roundedRect:CGRect(x:0,y:0,width:outSize,height:outSize),cornerWidth:rad,cornerHeight:rad,transform:nil)
  ctx.addPath(path); ctx.fillPath()
}
let longest=max(cw,ch)
let scale=(Double(outSize)*frac)/longest
let dw=cw*scale, dh=ch*scale
ctx.draw(crop, in: CGRect(x:(Double(outSize)-dw)/2, y:(Double(outSize)-dh)/2, width:dw, height:dh))
let out=ctx.makeImage()!
let rep=NSBitmapImageRep(cgImage:out)
try! rep.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:outPath))
print("wrote \(outPath) \(outSize)x\(outSize) bg=\(bg)")
