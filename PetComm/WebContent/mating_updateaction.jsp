<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%request.setCharacterEncoding("UTF-8");%>
<%@page import="java.io.File"%>
<%@page import="java.util.Enumeration"%>
 <%@ page import="com.oreilly.servlet.MultipartRequest, 
    				com.oreilly.servlet.multipart.DefaultFileRenamePolicy, 
    				java.io.File" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
String name = request.getParameter("name");
String subject = request.getParameter("subject");
/*
if(subject.length() < 1)
{
	subject = "제목없음";
}
if(name.length() < 1)
{
	name = "이름없음";
}*/
String lang = request.getParameter("lang");
if(lang == null)
{
	   lang = "korea";
}
String comment = request.getParameter("comment");
int number = Integer.parseInt(request.getParameter("number"));
Timestamp signdate = new Timestamp(System.currentTimeMillis());
String bpwd = null;
String what = request.getParameter("what");
%>


 <%
 Connection conn = null;
 PreparedStatement pstmt = null;
 String sql = null;

 try{
 	String jdbcUrl = "jdbc:mysql://localhost:3309/project";
 	String dbId = "jspid";
 	String dbPass = "jsppass";
 	
 	Class.forName ("com.mysql.jdbc.Driver"); //driver load
 	conn = DriverManager.getConnection(jdbcUrl,dbId,dbPass);
 	
 	
		String savePath = request.getRealPath("/uploadfiles");
 		
	     
 	    int maxSize =1024 *1024 *10;// 한번에 올릴 수 있는 파일 용량 : 10M로 제한
 	     
 	    String matingname ="";
 	    String matingsubject ="";
 	    String matingcomment ="";
 	    String matingfileName ="";
 	     
 	    String fileName1 ="";// 중복처리된 이름
 	    String originalName1 ="";// 중복 처리전 실제 원본 이름
 	    long fileSize =0;// 파일 사이즈
 	    String fileType ="";// 파일 타입
 	     
 	    MultipartRequest multi =null;
 	     
 	    try{
 	        // request,파일저장경로,용량,인코딩타입,중복파일명에 대한 기본 정책
 	        multi =new MultipartRequest(request,savePath,maxSize,"utf-8",new DefaultFileRenamePolicy());
 	         
 	         
 	        // form내의 input name="name" 인 녀석 value를 가져옴
 	        matingname = multi.getParameter("name");
 	        // name="subject" 인 녀석 value를 가져옴
 	        matingsubject = multi.getParameter("subject");
 	        
 	       matingcomment = multi.getParameter("comment");
 	         
 	        // 전송한 전체 파일이름들을 가져옴
 	        Enumeration files = multi.getFileNames();
 	         
 	        while(files.hasMoreElements()){
 	            // form 태그에서 <input type="file" name="여기에 지정한 이름" />을 가져온다.
 	            String file1 = (String)files.nextElement();// 파일 input에 지정한 이름을 가져옴
 	            // 그에 해당하는 실재 파일 이름을 가져옴
 	            originalName1 = multi.getOriginalFileName(file1);
 	            // 파일명이 중복될 경우 중복 정책에 의해 뒤에 1,2,3 처럼 붙어 unique하게 파일명을 생성하는데
 	            // 이때 생성된 이름을 filesystemName이라 하여 그 이름 정보를 가져온다.(중복에 대한 처리)
 	            fileName1 = multi.getFilesystemName(file1);
 	            // 파일 타입 정보를 가져옴
 	            fileType = multi.getContentType(file1);
 	            // input file name에 해당하는 실재 파일을 가져옴
 	            File file = multi.getFile(file1);
 	           matingfileName=file.getName();
 	            // 그 파일 객체의 크기를 알아냄
 	            fileSize = file.length();
 	        }
 	    }catch(Exception e){
 	        e.printStackTrace();
 	    }

		sql = "UPDATE  mating SET   subject = ?, comment = ?, signdate = ? , img = ? WHERE uid=?";
		pstmt = conn.prepareStatement(sql);
	 	pstmt.setString(1, matingsubject);
	 	pstmt.setString(2, matingcomment);
	 	pstmt.setTimestamp(3, signdate);
	 	pstmt.setString(4, matingfileName);
	 	pstmt.setInt(5, number);
	 	pstmt.executeUpdate();
 	


 		
 }catch(Exception e){
 	e.printStackTrace(); 
 }finally{
 	if(pstmt != null)
 		try{pstmt.close();}catch(SQLException sqle){}
 	if(conn != null)
 		try{conn.close();}catch(SQLException sqle){}
 }
 %>
<%if(lang.equals("korea")){%> 수정이 완료되었습니다.<%}else if(lang.equals("china")){%>修改已完成.<%}else if(lang.equals("america")){%>The modifications have been completed.<%}   %>
<meta http-equiv='Refresh' content='1; URL=index.jsp?target=qsmatingview&lang=<%=lang%>&number=<%= number %>'>


</body>
</html>