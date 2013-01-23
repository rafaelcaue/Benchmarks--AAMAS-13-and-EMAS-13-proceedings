import scala.actors.Actor
import scala.actors.Actor._
import java.lang.Long.MAX_VALUE

object threadring {

  class Thread(val label: Int) extends Actor {
    var next: Thread = null
    
    def act() { loop { react {
      case 0 => System.exit(0)
      case n: Int => next ! n - 1
    }}}
  }

  val ring = Array.tabulate(500)(i => new Thread(i + 1))

  ring.foreach(t => {
    t.next = ring( t.label % ring.length )
    t.start
  })

  def main(args : Array[String]) {
    ring(0) ! 500000
  }

}
