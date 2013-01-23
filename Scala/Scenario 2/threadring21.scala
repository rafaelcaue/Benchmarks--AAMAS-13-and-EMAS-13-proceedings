import scala.actors.Actor
import scala.actors.Actor._
import java.lang.Long.MAX_VALUE

object threadring {

  var counter = new Counting
  counter.start

  class Counting() extends Actor {
    var count: Int = 1
    def act() { loop { react {
       case 1 if count == 50 => System.exit(0)
       case 1 => count += 1
    }}}
  }

  class Thread(val label: Int) extends Actor {
    
    var next: Thread = null
    
    
    def act() { loop { react {
      case 0 => counter ! 1
      case n: Int => next ! n - 1
    }}}
  }
  
  val ring = Array.tabulate(500)(i => new Thread(i + 1))

  ring.foreach(t => {
    t.next = ring( t.label % ring.length )
    t.start
  })

  def main(args : Array[String]) {
    for(i <- 1 to 50){
    	ring(scala.math.round(i*(500/50)-1)) ! 500000
    }
  }
}
