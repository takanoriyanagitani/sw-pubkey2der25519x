import struct Foundation.Data
import class Foundation.FileHandle
import func PubkeyToDerX25519.raw2key2der4x25519

enum Key2derErr: Error {
  case invalidArgument(String)
}

func reader2raw32bytes(
  _ reader: FileHandle = .standardInput,
) -> Result<Data, Error> {
  Result(catching: { try reader.read(upToCount: 32) ?? Data() })
    .flatMap {
      let dat: Data = $0
      guard 32 == dat.count else {
        return .failure(Key2derErr.invalidArgument("unexpected size"))
      }
      return .success(dat)
    }
}

func data2writer(
  writer: FileHandle = .standardOutput,
) -> (Data) -> Result<(), Error> {
  return {
    let dat: Data = $0
    return Result(catching: { try writer.write(contentsOf: dat) })
  }
}

@main
struct PubkeyToDerForX25519Cli {
  static func main() {
    let dat2stdout: (Data) -> Result<(), Error> = data2writer()

    let rkey: Result<Data, _> = reader2raw32bytes()
    let rder: Result<Data, _> = rkey.flatMap(raw2key2der4x25519)
    let rwrote: Result<Void, _> = rder.flatMap(dat2stdout)

    do {
      try rwrote.get()
    } catch {
      print("error: \( error )")
    }
  }
}
