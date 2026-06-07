import AppKit
import CoreGraphics

let W = 1200, H = 630
let logoPath = "public/assets/logo/adcab-white.png"
let outPath = "public/og-image.png"

func hex(_ s:String,_ a:CGFloat=1)->NSColor {
  func c(_ i:Int)->CGFloat { CGFloat(Int(s[s.index(s.startIndex,offsetBy:i)..<s.index(s.startIndex,offsetBy:i+2)],radix:16)!)/255 }
  return NSColor(red:c(0),green:c(2),blue:c(4),alpha:a)
}
let navy = hex("0E2841"), navyDark = hex("081B2E"), magenta = hex("E5197D"), slate = hex("9AA9B8")

let rep = NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:W,pixelsHigh:H,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
let gc = NSGraphicsContext(bitmapImageRep:rep)!
NSGraphicsContext.current = gc
let ctx = gc.cgContext

// background gradient (navy -> darker)
let grad = NSGradient(colors:[navy,navyDark])!
grad.draw(in: NSRect(x:0,y:0,width:W,height:H), angle: -90)

// soft magenta glow lower-right
ctx.saveGState()
let glow = NSGradient(colors:[hex("E5197D",0.20), hex("E5197D",0.0)])!
glow.draw(fromCenter: NSPoint(x:W-150,y:120), radius:0, toCenter: NSPoint(x:W-150,y:120), radius:520, options:[])
ctx.restoreGState()

// subtle top hairline accent
magenta.setFill()
NSRect(x:0,y:H-6,width:W,height:6).fill()

// kicker
let para = NSMutableParagraphStyle(); para.alignment = .center
func draw(_ s:String,_ font:NSFont,_ color:NSColor,_ topY:CGFloat,_ kern:CGFloat=0){
  let attrs:[NSAttributedString.Key:Any]=[.font:font,.foregroundColor:color,.kern:kern,.paragraphStyle:para]
  let str=NSAttributedString(string:s,attributes:attrs)
  let sz=str.size()
  str.draw(at:NSPoint(x:(CGFloat(W)-sz.width)/2, y:CGFloat(H)-topY-sz.height))
}
draw("ONCOLYTIC IMMUNOTHERAPY · PRE-CLINICAL",
     NSFont(name:"HelveticaNeue-Medium",size:24) ?? .systemFont(ofSize:24,weight:.medium),
     magenta, 120, 4)

// logo wordmark centered
if let img=NSImage(contentsOfFile:logoPath), let cg=img.cgImage(forProposedRect:nil,context:nil,hints:nil){
  let lw:CGFloat=620, lh=lw*CGFloat(cg.height)/CGFloat(cg.width)
  let lx=(CGFloat(W)-lw)/2, ly=CGFloat(H)-200-lh
  ctx.draw(cg, in: CGRect(x:lx,y:ly,width:lw,height:lh))
}

// tagline
draw("Striking cancer at its Achilles\u{2019} heel",
     NSFont(name:"HelveticaNeue-Bold",size:48) ?? .systemFont(ofSize:48,weight:.bold),
     .white, 360)
// subtitle
draw("A dual-action oncolytic immunotherapy for the hardest-to-treat cancers",
     NSFont(name:"HelveticaNeue",size:25) ?? .systemFont(ofSize:25,weight:.regular),
     slate, 432)
// url
draw("adcab.org",
     NSFont(name:"HelveticaNeue-Medium",size:22) ?? .systemFont(ofSize:22,weight:.medium),
     slate, 548, 2)

gc.flushGraphics()
try! rep.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:outPath))
print("wrote \(outPath) \(W)x\(H)")
