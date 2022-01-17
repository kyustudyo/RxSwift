import UIKit
import RxSwift
import RxCocoa

let observable1 = Observable.just(1)// observe
let observable2 = Observable.of(1,2,3)// observe
let observable3 = Observable.of([1,2,3])// observe
let observable4 = Observable.from([1,2,3,4])// observe

observable4.subscribe{ event in// subscribe
    print(event)
}

observable4.subscribe{ event in
    if let element = event.element {
        print(element)
    }
}

observable4.subscribe(onNext:{ element in
    print(element)
})

observable3.subscribe{ event in
    print("observce3_",event)
}

observable3.subscribe{ event in
    if let element = event.element {
        print(element)
    }
}
observable3.subscribe(onNext:{ element in
    print(element)
})

//if we don't dispose subscrbers, memory leak.

let subscription4 = observable4.subscribe(onNext:{ element in
    print(element)
})
subscription4.dispose()

let disposeBag = DisposeBag()
Observable.of("a","b","c")
    .subscribe{
        print($0)
}.disposed(by: disposeBag)

//observation의 또 다른 방법. 그러나 위의 방법들 사용할 것.
Observable<String>.create { observer in
    observer.onNext("A")
    observer.onCompleted()
    observer.onNext("?")
    return Disposables.create()
    
}.subscribe { print($0)
    
} onError: {
    print("err",$0)
} onCompleted: {
    print("complete~~")
} onDisposed: {
    print("dispose~~")
}.disposed(by: disposeBag)


//publsih subject

let subject = PublishSubject<String>()
subject.onNext("issue 1")// no
subject.subscribe{ event in
    print(event)
}
subject.onNext("issue 2")
subject.onNext("issue 3")
subject.dispose()//이걸하면 아무것도 없이 끝남
subject.onCompleted()//이걸하면 콤플릿 말함.
subject.onNext("issue 4")

// behavior
let behaviorSubject = BehaviorSubject(value: "behaviorSubject initial")
//마지막에 받은것을 출력.
behaviorSubject.onNext("이것은?")
behaviorSubject.onNext("이게 있으면 위에것을 안함.")
//publish subject와 비슷하지만, 이것이 차이.
behaviorSubject.subscribe{event in
    print(event)
}
behaviorSubject.onNext("behaviorSubject 1")
behaviorSubject.onNext("behaviorSubject 2")

//replay subject
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
replaySubject.onNext("1")// no
replaySubject.onNext("2")
replaySubject.onNext("3")
replaySubject.subscribe{
    print("replay:",$0)
}
replaySubject.onNext("4")
replaySubject.onNext("5")
replaySubject.onNext("6")
replaySubject.onNext("7")
print("replay subscription 2")
replaySubject.subscribe{
    print("replay2",$0)
}

//Varibale _ deprecated

let variable = Variable([String]())
variable.value.append("item1")
variable.asObservable()
    .subscribe{
        print($0)
    }
variable.value.append("item2")

//relay_ cocoa pod 필요.

let relay = BehaviorRelay(value: "inital v")
relay.asObservable()
    .subscribe{
        print($0)
    }
//relay.value = "d"//불가능
relay.accept("new val")
relay.accept("new val2")
let relay2 = BehaviorRelay(value: [String]())
//relay2.value.append("item22")//불가능
relay2.accept(["item ad"])
relay2.asObservable()
    .subscribe{
        print($0)
    }

let relay3 = BehaviorRelay(value: ["qqq"])
//relay2.value.append("item22")//불가능
relay3.accept(["item jjjj"])
relay3.asObservable()
    .subscribe{
        print($0)
    }//qqq는 사라짐.


let relay4 = BehaviorRelay(value: ["qqq"])
relay4.accept(relay4.value + ["item jjjj"])
relay4.asObservable()
    .subscribe{
        print($0)
    }
relay4.accept(relay4.value + ["item aaaa"])

//var 로 선언
let relay5 = BehaviorRelay(value: ["qqq"])
var realy5Value = relay5.value
realy5Value.append("jjj")
realy5Value.append("kkk")
relay5.accept(realy5Value)
relay5.asObservable()
    .subscribe{
        print($0)
    }
