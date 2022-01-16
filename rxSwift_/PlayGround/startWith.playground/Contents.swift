import UIKit
import RxSwift

//startWith
let disposeBag = DisposeBag()

let numbers = Observable.of(2,3,4)
let observable = numbers.startWith(1)
observable.subscribe(onNext:{
    print($0)
}).disposed(by: disposeBag)


//concat
let first = Observable.of(1,2,3)
let second = Observable.of(4,5,6)

let observable2 = Observable.concat([first,second])

observable2.subscribe(onNext:{
    print($0)
}).disposed(by: disposeBag)

//Merge
let left = PublishSubject<Int>()
let right = PublishSubject<Int>()

let source = Observable.of(left.asObserver(),right.asObserver())
let observable3 = source.merge()
observable3.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)
left.onNext(1)
left.onNext(3)
right.onNext(2)
right.onNext(4)
left.onNext(6)

//
print("combineLatese")
let left2 = PublishSubject<Int>()
let right2 = PublishSubject<Int>()

let observable4 = Observable.combineLatest(left2,right2,resultSelector: {
    lastLeft, lastRight in
    "\(lastLeft) \(lastRight)"
})
let disposable = observable4.subscribe(onNext: {value in
    print(value)
})
left2.onNext(45)
right2.onNext(1)
left2.onNext(30)
right2.onNext(1)
right2.onNext(2)

//withlatestfrom

let button = PublishSubject<Void>()
let textField = PublishSubject<String>()
let observable9 = button.withLatestFrom(textField)
let disposable9 = observable9.subscribe(onNext:{
    print($0)
})
textField.onNext("Sw")
textField.onNext("Swi")
textField.onNext("Swif")
textField.onNext("Swift")
textField.onNext("Swift Rocks!")
button.onNext(())
button.onNext(())

//reduce

let source9 = Observable.of(1,2,3)
source9.reduce(0,accumulator: +)
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

source9.reduce(0, accumulator: {
    summary, newValue in
    return summary + newValue
}).subscribe(onNext:{
    print($0)
}).disposed(by: disposeBag)

//scan
//1,2,3 -> 1,3,6
let source10 = Observable.of(1,2,3,4,5,6)
source10.scan(0,accumulator: +)
    .subscribe(onNext:{
        print($0)
    }).disposed(by: disposeBag)

