import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

//toarray
Observable.of(1,2,3,4,5)
    .toArray()
    .subscribe(onNext:{
        print($0)
    }).disposed(by: disposeBag)

//map
Observable.of(1,2,3,4,5)
    .map{
        return $0 * 2
    }.subscribe(onNext:{
        print($0)
    }).disposed(by: disposeBag)

//flatmap - 내부의 observable 바꿀때 유용
struct Student {
    var score : BehaviorRelay<Int>
}

let john = Student(score: BehaviorRelay(value: 75))
let mary = Student(score: BehaviorRelay(value: 95))

let student = PublishSubject<Student>()
student.asObserver()
    .flatMap{ $0.score.asObservable() }
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
student.onNext(john)
//john.score.value = 100 //err
john.score.accept(100)

student.onNext(mary)
mary.score.accept(80)
john.score.accept(12)

//

let kay = Student(score: BehaviorRelay(value: 123))
let jau = Student(score: BehaviorRelay(value: 999))
let teacher = PublishSubject<Student>()
teacher.asObserver()
    .flatMapLatest{ $0.score.asObservable() }
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
teacher.onNext(kay)
kay.score.accept(111)

teacher.onNext(jau)
kay.score.accept(911)// no 마지막에 들어온 얘만.
