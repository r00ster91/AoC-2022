fn main() {
    let input = include_str!("input");
    let stack_count = (input.lines().next().unwrap().len() + 1) / 4;
    let mut stacks = vec![vec![]; stack_count];

    // first, parse the initial stacks' state
    let mut lines = input.lines();
    for line in &mut lines {
        let mut parsing_finished = false;
        for (stack_index, stack) in stacks.iter_mut().enumerate() {
            // we "should" use `bytes()` because we know all the input is ASCII
            // but in Rust this is just more convenient albeit slower.
            let stack_crate = line.chars().nth(stack_index * 4 + 1).unwrap();
            if stack_crate.is_ascii_digit() {
                parsing_finished = true;
            } else if stack_crate != ' ' {
                stack.push(stack_crate);
            }
        }
        if parsing_finished {
            // now follow move instructions
            break;
        }
    }
    for stack in &mut stacks {
        stack.reverse();
    }

    assert!(lines.next().unwrap().is_empty());

    // now, interpret the move instructions and move the crates from stack to stack
    for line in lines {
        let mut line_parts = line.split(' ');
        assert!(line_parts.next().unwrap() == "move");
        let crates_to_move_count = line_parts.next().unwrap().parse::<usize>().unwrap();
        assert!(line_parts.next().unwrap() == "from");
        let source_stack_index = line_parts.next().unwrap().parse::<usize>().unwrap() - 1;
        assert!(line_parts.next().unwrap() == "to");
        let destination_stack_index = line_parts.next().unwrap().parse::<usize>().unwrap() - 1;
        let mut crates_to_push = Vec::<char>::new();
        for _ in 0..crates_to_move_count {
            let source_stack = stacks.get_mut(source_stack_index).unwrap();
            let popped_crate = source_stack.pop().unwrap();
            crates_to_push.push(popped_crate);
        }
        /*--------------------------------------------*\
        |  Uncomment this for the answer to part two!  |
        \*--------------------------------------------*/
        //crates_to_push.reverse();
        let destination_stack = stacks.get_mut(destination_stack_index).unwrap();
        destination_stack.append(&mut crates_to_push);
    }

    for stack in &mut stacks {
        print!("{}", stack.pop().unwrap());
    } 
    println!();
}
