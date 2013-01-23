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

  class SubActor(val n: Int) extends Actor {

    var father: Thread = null

    def act() { loop { react {
       case 1 => for(i <- 1 to 1000){}; father ! ((1,n,0)); exit()
    }}}
  }

  class Thread(val label: Int) extends Actor {
    
    var next: Thread = null
    	
    
    def act() { loop { react {
      case (2,0) => counter ! 1
      case (2,n : Int) => next ! (2,n - 1)
      case (1,n : Int) => var sub = new SubActor(n); sub.father = ring(label-1); sub.start; sub ! 1
      case (1,n : Int,0) => next ! (1,n)
    }}}
  }
  
  val ring = Array.tabulate(500)(i => new Thread(i + 1))

  ring.foreach(t => {
    t.next = ring( t.label % ring.length )
    t.start
  })

  def main(args : Array[String]) {
    for(i <- 1 to 2){
	    for(i <- 0 to 499){
    		ring(i) ! (1,500)
	    }
    }
    for(i <- 1 to 50){
    	ring((i*(500/50))-1) ! (2,500)
    }
  }
}
