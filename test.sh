#!/bin/bash
# 学生登录功能
function student_login() {

    echo "学生身份登录系统"

    read -p "请输入用户名：" student_id
    read -s -p "请输入密码：" password
    echo

    case $student_id in
        "stu1")
            if [ "$password" = "111" ]; then student_name=xiaoming
                echo "登录成功！欢迎stu1 $student_name"
		student_menu
                # 执行登录后的操作
            else
                echo "用户名或密码不正确！"
		main_menu
            fi
            ;;
        "stu2")
            if [ "$password" = "222" ]; then student_name=xiaohong
                echo "登录成功！欢迎stu2 $student_name"
		student_menu
                # 执行登录后的操作
            else
                echo "用户名或密码不正确！"
		main_menu
            fi
            ;;
        "stu3")
            if [ "$password" = "333" ]; then student_name=xiaodong
                echo "登录成功！欢迎stu3 $student_name"
		student_menu
                # 执行登录后的操作
            else
                echo "用户名或密码不正确！"
		main_menu
            fi
            ;;
        *)
            echo "用户名或密码不正确！"
		main_menu
            ;;
    esac
}

function load_selected_courses {
    selected_courses=()
    while IFS= read -r line; do
        selected_courses+=("$line")
    done < "$selected_courses_file"
}


# 学生选课功能
function student_select_course() {
    echo "学生选择课程"
students=()

load_courses

load_selected_courses

 echo "请选择要添加的课程（输入课程编号）："
      for i in "${!courses[@]}"; do
        echo "$i. ${courses[$i]}"
    done

    read -r course_id
    if [[ "$course_id" =~ ^[0-9]+$ ]] && (( course_id >= 0 )) && (( course_id < ${#courses[@]} )); then
        # 检查是否已经选过该课程
        for line in "${selected_courses[@]}"; do
            info=($(echo "$line" | tr ',' ' '))
            if [[ "${info[0]}" == "$student_id" && "${info[3]}" == "$course_id" ]]; then
                echo "您已经选过该课程。"
                return
            fi
        done
        # 添加选课
        students+=("$student_id" "$student_name" "${courses[$course_id]}" "$course_id")
        echo "选课成功！"
        echo "$student_id,$student_name,${courses[$course_id]},$course_id" >> "selected_courses.txt"
        
    else
        echo "输入有误，请重新选择。"
        student_select_course
    fi
}

# 学生查看信息功能
function student_view_info() {
    echo "学生查看信息"
echo "您的选课信息如下："
    for line in "${selected_courses[@]}"; do
        info=($(echo "$line" | tr ',' ' '))
        if [[ "${info[0]}" == "$student_id" ]]; then
            course_id="${info[3]}"
            echo "${courses[$course_id]}"
        fi
    done
    found=false
    while IFS= read -r line; do
        info=($(echo "$line" | tr ',' ' '))
        if [[ "${info[0]}" == "$student_id" && "${info[1]}" == "$student_name" ]]; then
            found=true
            course_name="${info[2]}"
            course_id="${info[3]}"
            echo "学号：$student_id，姓名：$student_name，选课信息：$course_name（编号：$course_id）"
        fi
    done < "selected_courses.txt"
    if [[ "$found" == false ]]; then
        echo "未找到该学生的选课信息。"
    fi
}	

    # 添加学生查看信息逻辑


# 教师登录功能
function teacher_login() {
    echo "教师身份登录系统"
    # 添加教师登录逻辑
}

function load_courses {
# 课程数组文件
courses_file="course.txt"

# 学生选课信息文件
selected_courses_file="selected_courses.txt"

# 课程数组
courses=()

    courses=()
    while IFS= read -r line; do
        courses+=("$line")
    done < "$courses_file"
}

# 教师添加课程功能
function teacher_add_course() {

    echo "教师添加课程"
# 课程数组文件
courses_file="course.txt"

# 学生选课信息文件
selected_courses_file="selected_courses.txt"

# 课程数组
courses=()

    # 添加教师添加课程逻辑
	echo "请输入课程名称："
    read -r course_name
    courses+=("$course_name")
    save_courses
    echo "课程添加成功！"

}

function save_selected_courses {
    for course in "${selected_courses[@]}"; do
        echo "$course" >> "$selected_courses_file"
    done
}


function save_courses {


    for course in "${courses[@]}"; do
        echo "$course" >> "$courses_file"
    done

}

# 教师删除课程功能
function teacher_delete_course() {
    echo "教师删除课程"
	# 课程数组文件
load_courses
selected_courses_file="selected_courses.txt"
load_selected_courses
courses_file="course.txt"
    # 添加教师删除课程逻辑
	echo "请选择要删除的课程（输入课程编号）："
    for i in "${!courses[@]}"; do
        echo "$i. ${courses[$i]}"
    done
    read -r course_id
    if [[ "$course_id" =~ ^[0-9]+$ ]] && (( course_id >= 0 )) && (( course_id < ${#courses[@]} )); then
        # 删除选课信息
        while IFS= read -r line; do
            info=($(echo "$line" | tr ',' ' '))
            if [[ "${info[3]}" == "$course_id" ]]; then
                sed -i "/^${info[0]},${info[1]},${info[2]},$course_id$/d" "$selected_courses_file"
            fi
        done < "$selected_courses_file"
	
	for i in "${!selected_courses[@]}"; do
        info=($(echo "${selected_courses[$i]}" | tr ',' ' '))
        if [[ "${info[3]}" == "$course_id" ]]; then
            unset selected_courses[$i]
	fi
       done		
	
		for i in "${!selected_courses[@]}"; do
       		  info=($(echo "${selected_courses[$i]}" | tr ',' ' '))
			if [[ "${info[3]}" -gt "$course_id" ]]; then
				info[3]=$((info[3]-1))
			selected_courses[$i]="${info[0]},${info[1]},${info[2]},${info[3]}"
		
 				fi   
			done
		printf "%s\n" "${selected_courses[@]}" > "$selected_courses_file"
        # 删除课程
        courses=("${courses[@]:0:$course_id}" "${courses[@]:$(( course_id + 1 ))}")
		> course.txt

	 
        echo "选课信息已删除。"
save_courses
    else
        echo "输入无效，请重试。"
    

       
        
   
        
       teacher_delete_course
    fi
}

# 教师查看课程功能
function teacher_view_course() {
    echo "教师查看课程"
	# 课程数组文件
courses_file="course.txt"
    # 添加教师查看课程逻辑
	echo "请选择要查看的课程（输入课程编号）："
    for i in "${!courses[@]}"; do
        echo "$i. ${courses[$i]}"
    done	
    read -r course_id
    if [[ "$course_id" =~ ^[0-9]+$ ]] && (( course_id >= 0 )) && (( course_id < ${#courses[@]} )); then
        count=$(grep -c "^.*,.*,${courses[$course_id]},$course_id$" "$selected_courses_file")
        echo "${courses[$course_id]}的选课人数为：$count"
    else
        echo "输入有误，请重新选择。"
        view_course_count
    fi
}
# 显示学生主界面
function display_student_menu() {
    echo "----------------------欢迎使用学生选课系统（学生）------------------------"
echo "*                  1、学生选择课程                        *"
    echo "*                  2、学生查看信息                        *"
    echo "*                  3、学生退出系统                        *"
echo "----------------------------------------------------------------------------------------"
}
# 显示教师主界面
function display_teacher_menu() {
    echo "----------------------欢迎使用学生选课系统（教师）------------------------"
    echo "*                  1、教师添加课程                        *"
    echo "*                  2、教师删除课程                        *"
    echo "*                  3、教师查看课程                        *"
    echo "*                  4、教师退出系统                        *"
    echo "----------------------------------------------------------------------------------------"
}

# 主菜单
function main_menu() {
    while true; do
        echo "----------------------------欢迎使用学生选课系统------------------------------"
        echo "*                1、学生身份登录系统                      *"
        echo "*                2、教师身份登录系统                      *"
        echo "*                3、退出学生选课系统                      *"
        echo "----------------------------------------------------------------------------------------"

# 判断当前用户属于哪个组 获取用户所述祖列表
if id -nG "$(whoami)" | grep -qw "student"; then
    user_type="student"
elif id -nG "$(whoami)" | grep -qw "teacher"; then
    user_type="teacher"
else
    echo "Error: Current user is not in student or teacher group."
    exit 1
fi


        read -p "请输入选项：" option
	
        case $option in
            1)
		if [[ "$user_type" == "student" ]];then 
    echo "Welcome, student!"
    # 学生界面的代码
                student_login
                else	echo "警告，非学生无法登陆学生端！！！"
		 main_menu
fi
                ;;
            2)
		if [[ "$user_type" == "teacher" ]]; then
    echo "Welcome, teacher!"
    # 教师界面的代码

  	            teacher_menu
	else	echo "警告，非教师无法登陆教师端！！！"

		 main_menu
fi              
                ;;
            3)
                echo "退出学生选课系统"
                break
                ;;
            *)
                echo "无效的选项，请重新输入"
                ;;
        esac
    done
}

# 学生菜单
function student_menu() {
    while true; do
        display_student_menu

        read -p "请输入选项：" option

        case $option in
            1)	
		

                student_select_course

                ;;
            2)
                student_view_info
                ;;
            3)
                echo "学生退出系统"
                break
                ;;
            *)
                echo "无效的选项，请重新输入"
                ;;
        esac
    done
}

# 教师菜单
function teacher_menu() {
    while true; do
        display_teacher_menu
	load_courses
        read -p "请输入选项：" option

        case $option in
            1)
                teacher_add_course
                ;;
            2)
                teacher_delete_course
                ;;
            3)
                teacher_view_course
                ;;
            4)
                echo "教师退出系统"
                break
                ;;
            *)
                echo "无效的选项，请重新输入"
                ;;
        esac
    done
}


# 运行主菜单
main_menu
load_courses
selected_courses_file="selected_courses.txt"
load_selected_courses
