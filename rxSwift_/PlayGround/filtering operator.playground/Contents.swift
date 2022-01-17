import UIKit
import RxSwift
import PlaygroundSupport

let strikes = PublishSubject<String>()
let disposeBag = DisposeBag()

strikes
    .ignoreElements()
    .subscribe { _ in
        print("subb is called")
    }.disposed(by: disposeBag)

strikes.onNext("a")
strikes.onNext("b")
strikes.onNext("c")
// no call 하다가 컴플릿 해야지 작동
strikes.onCompleted()
strikes.onNext("a after comp")
// element at
let strikes2 = PublishSubject<String>()
strikes2.elementAt(2)
    .subscribe(onNext:{ _ in
        print("you ar our!")
    }).disposed(by: disposeBag)
strikes2.onNext("1")
strikes2.onNext("2")
strikes2.onNext("3")
strikes2.onNext("4")

//filter
Observable.of(1,2,3,4,5,6,7)
    .filter{ $0 % 2 == 0}
    .subscribe(onNext:{
        print($0)
    }).disposed(by: disposeBag)

//skip
Observable.of("a","b","c","d")
    .skip(3)
    .subscribe(onNext:{
        print($0)
    }).disposed(by: disposeBag)

//skip while
//연속적인 2 를 지나면 다음은 적용안됨.
Observable.of(2,2,2,3,4,4,4)
    .skipWhile{$0 % 2 == 0}
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

//skipuntil
//trigger 이후에 진행
let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()
subject.skipUntil(trigger)
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
subject.onNext("a")
subject.onNext("b")
subject.onNext("c")
trigger.onNext("start!")
subject.onNext("d")
subject.onNext("e")

//take
//앞에 3개
Observable.of(1,2,3,4,5,6,7)
    .take(3)
    .subscribe(onNext:{
        print($0)
    }).disposed(by: disposeBag)

//takeWhile
print("takewhile")
//8 안함.
Observable.of(2,4,6,7,8,10)
    .takeWhile{
        return $0 % 2 == 0
    }.subscribe(onNext:{
        print($0)
    }).disposed(by: disposeBag)

//takeUntil

print("takeUntil")
let subject2 = PublishSubject<String>()
let trigger2 = PublishSubject<String>()

subject2.takeUntil(trigger2)
    .subscribe(onNext:{
        print($0)
    }).disposed(by: disposeBag)
subject2.onNext("1")
subject2.onNext("2")
trigger2.onNext("X")
subject2.onNext("3")

