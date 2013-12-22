Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab3LVHgp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 02:36:45 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:57517 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3LVHgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 02:36:43 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org, yann.morin.1998@free.fr,
        linux-kbuild@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 1/2] [trivial] scripts: kconfig: Fix trailing whitespace in zconf.lex.c_shipped
Date: Sun, 22 Dec 2013 16:36:24 +0900
Message-Id: <1387697785-29767-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixed "Error: trailing whitespace" found by
checkpatch.pl in scripts/kconfig/zconf.lex.c_shipped

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 scripts/kconfig/zconf.lex.c_shipped | 86 ++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 43 deletions(-)

diff --git a/scripts/kconfig/zconf.lex.c_shipped b/scripts/kconfig/zconf.lex.c_shipped
index a0521aa..83c8c5b 100644
--- a/scripts/kconfig/zconf.lex.c_shipped
+++ b/scripts/kconfig/zconf.lex.c_shipped
@@ -52,7 +52,7 @@
 #if defined (__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
 
 /* C99 says to define __STDC_LIMIT_MACROS before including stdint.h,
- * if you want the limit (max/min) macros for int types. 
+ * if you want the limit (max/min) macros for int types.
  */
 #ifndef __STDC_LIMIT_MACROS
 #define __STDC_LIMIT_MACROS 1
@@ -69,7 +69,7 @@ typedef uint32_t flex_uint32_t;
 typedef signed char flex_int8_t;
 typedef short int flex_int16_t;
 typedef int flex_int32_t;
-typedef unsigned char flex_uint8_t; 
+typedef unsigned char flex_uint8_t;
 typedef unsigned short int flex_uint16_t;
 typedef unsigned int flex_uint32_t;
 #endif /* ! C99 */
@@ -180,7 +180,7 @@ extern FILE *zconfin, *zconfout;
 #define EOB_ACT_LAST_MATCH 2
 
     #define YY_LESS_LINENO(n)
-    
+
 /* Return all but the first "n" matched characters back to the input stream. */
 #define yyless(n) \
 	do \
@@ -242,7 +242,7 @@ struct yy_buffer_state
 
     int yy_bs_lineno; /**< The line count. */
     int yy_bs_column; /**< The column count. */
-    
+
 	/* Whether to try to fill the input buffer when we reach the
 	 * end of it.
 	 */
@@ -891,7 +891,7 @@ extern int zconfwrap (void );
 #endif
 
     static void yyunput (int c,char *buf_ptr  );
-    
+
 #ifndef yytext_ptr
 static void yy_flex_strncpy (char *,yyconst char *,int );
 #endif
@@ -996,7 +996,7 @@ YY_DECL
 	register yy_state_type yy_current_state;
 	register char *yy_cp, *yy_bp;
 	register int yy_act;
-    
+
 	int str = 0;
 	int ts, i;
 
@@ -1607,7 +1607,7 @@ static int yy_get_next_buffer (void)
 {
 	register yy_state_type yy_current_state;
 	register char *yy_cp;
-    
+
 	yy_current_state = (yy_start);
 
 	for ( yy_cp = (yytext_ptr) + YY_MORE_ADJ; yy_cp < (yy_c_buf_p); ++yy_cp )
@@ -1626,7 +1626,7 @@ static int yy_get_next_buffer (void)
     static yy_state_type yy_try_NUL_trans  (yy_state_type yy_current_state )
 {
 	register int yy_is_jam;
-    
+
 	yy_current_state = yy_nxt[yy_current_state][1];
 	yy_is_jam = (yy_current_state <= 0);
 
@@ -1636,7 +1636,7 @@ static int yy_get_next_buffer (void)
     static void yyunput (int c, register char * yy_bp )
 {
 	register char *yy_cp;
-    
+
     yy_cp = (yy_c_buf_p);
 
 	/* undo effects of setting up zconftext */
@@ -1679,7 +1679,7 @@ static int yy_get_next_buffer (void)
 
 {
 	int c;
-    
+
 	*(yy_c_buf_p) = (yy_hold_char);
 
 	if ( *(yy_c_buf_p) == YY_END_OF_BUFFER_CHAR )
@@ -1746,12 +1746,12 @@ static int yy_get_next_buffer (void)
 
 /** Immediately switch to a different input stream.
  * @param input_file A readable stream.
- * 
+ *
  * @note This function does not reset the start condition to @c INITIAL .
  */
     void zconfrestart  (FILE * input_file )
 {
-    
+
 	if ( ! YY_CURRENT_BUFFER ){
         zconfensure_buffer_stack ();
 		YY_CURRENT_BUFFER_LVALUE =
@@ -1764,11 +1764,11 @@ static int yy_get_next_buffer (void)
 
 /** Switch to a different input buffer.
  * @param new_buffer The new input buffer.
- * 
+ *
  */
     void zconf_switch_to_buffer  (YY_BUFFER_STATE  new_buffer )
 {
-    
+
 	/* TODO. We should be able to replace this entire function body
 	 * with
 	 *		zconfpop_buffer_state();
@@ -1808,13 +1808,13 @@ static void zconf_load_buffer_state  (void)
 /** Allocate and initialize an input buffer state.
  * @param file A readable stream.
  * @param size The character buffer size in bytes. When in doubt, use @c YY_BUF_SIZE.
- * 
+ *
  * @return the allocated buffer state.
  */
     YY_BUFFER_STATE zconf_create_buffer  (FILE * file, int  size )
 {
 	YY_BUFFER_STATE b;
-    
+
 	b = (YY_BUFFER_STATE) zconfalloc(sizeof( struct yy_buffer_state )  );
 	if ( ! b )
 		YY_FATAL_ERROR( "out of dynamic memory in zconf_create_buffer()" );
@@ -1837,11 +1837,11 @@ static void zconf_load_buffer_state  (void)
 
 /** Destroy the buffer.
  * @param b a buffer created with zconf_create_buffer()
- * 
+ *
  */
     void zconf_delete_buffer (YY_BUFFER_STATE  b )
 {
-    
+
 	if ( ! b )
 		return;
 
@@ -1862,7 +1862,7 @@ static void zconf_load_buffer_state  (void)
 
 {
 	int oerrno = errno;
-    
+
 	zconf_flush_buffer(b );
 
 	b->yy_input_file = file;
@@ -1878,13 +1878,13 @@ static void zconf_load_buffer_state  (void)
     }
 
         b->yy_is_interactive = 0;
-    
+
 	errno = oerrno;
 }
 
 /** Discard all buffered characters. On the next scan, YY_INPUT will be called.
  * @param b the buffer state to be flushed, usually @c YY_CURRENT_BUFFER.
- * 
+ *
  */
     void zconf_flush_buffer (YY_BUFFER_STATE  b )
 {
@@ -1913,7 +1913,7 @@ static void zconf_load_buffer_state  (void)
  *  the current state. This function will allocate the stack
  *  if necessary.
  *  @param new_buffer The new state.
- *  
+ *
  */
 void zconfpush_buffer_state (YY_BUFFER_STATE new_buffer )
 {
@@ -1943,7 +1943,7 @@ void zconfpush_buffer_state (YY_BUFFER_STATE new_buffer )
 
 /** Removes and deletes the top of the stack, if present.
  *  The next element becomes the new top.
- *  
+ *
  */
 void zconfpop_buffer_state (void)
 {
@@ -1967,7 +1967,7 @@ void zconfpop_buffer_state (void)
 static void zconfensure_buffer_stack (void)
 {
 	int num_to_alloc;
-    
+
 	if (!(yy_buffer_stack)) {
 
 		/* First allocation is just for 2 elements, since we don't know if this
@@ -1980,9 +1980,9 @@ static void zconfensure_buffer_stack (void)
 								);
 		if ( ! (yy_buffer_stack) )
 			YY_FATAL_ERROR( "out of dynamic memory in zconfensure_buffer_stack()" );
-								  
+
 		memset((yy_buffer_stack), 0, num_to_alloc * sizeof(struct yy_buffer_state*));
-				
+
 		(yy_buffer_stack_max) = num_to_alloc;
 		(yy_buffer_stack_top) = 0;
 		return;
@@ -2010,13 +2010,13 @@ static void zconfensure_buffer_stack (void)
 /** Setup the input buffer state to scan directly from a user-specified character buffer.
  * @param base the character buffer
  * @param size the size in bytes of the character buffer
- * 
- * @return the newly allocated buffer state object. 
+ *
+ * @return the newly allocated buffer state object.
  */
 YY_BUFFER_STATE zconf_scan_buffer  (char * base, yy_size_t  size )
 {
 	YY_BUFFER_STATE b;
-    
+
 	if ( size < 2 ||
 	     base[size-2] != YY_END_OF_BUFFER_CHAR ||
 	     base[size-1] != YY_END_OF_BUFFER_CHAR )
@@ -2045,14 +2045,14 @@ YY_BUFFER_STATE zconf_scan_buffer  (char * base, yy_size_t  size )
 /** Setup the input buffer state to scan a string. The next call to zconflex() will
  * scan from a @e copy of @a str.
  * @param yystr a NUL-terminated string to scan
- * 
+ *
  * @return the newly allocated buffer state object.
  * @note If you want to scan bytes that may contain NUL values, then use
  *       zconf_scan_bytes() instead.
  */
 YY_BUFFER_STATE zconf_scan_string (yyconst char * yystr )
 {
-    
+
 	return zconf_scan_bytes(yystr,strlen(yystr) );
 }
 
@@ -2060,7 +2060,7 @@ YY_BUFFER_STATE zconf_scan_string (yyconst char * yystr )
  * scan from a @e copy of @a bytes.
  * @param bytes the byte buffer to scan
  * @param len the number of bytes in the buffer pointed to by @a bytes.
- * 
+ *
  * @return the newly allocated buffer state object.
  */
 YY_BUFFER_STATE zconf_scan_bytes  (yyconst char * yybytes, int  _yybytes_len )
@@ -2069,7 +2069,7 @@ YY_BUFFER_STATE zconf_scan_bytes  (yyconst char * yybytes, int  _yybytes_len )
 	char *buf;
 	yy_size_t n;
 	int i;
-    
+
 	/* Get memory for full buffer, including space for trailing EOB's. */
 	n = _yybytes_len + 2;
 	buf = (char *) zconfalloc(n  );
@@ -2123,16 +2123,16 @@ static void yy_fatal_error (yyconst char* msg )
 /* Accessor  methods (get/set functions) to struct members. */
 
 /** Get the current line number.
- * 
+ *
  */
 int zconfget_lineno  (void)
 {
-        
+
     return zconflineno;
 }
 
 /** Get the input stream.
- * 
+ *
  */
 FILE *zconfget_in  (void)
 {
@@ -2140,7 +2140,7 @@ FILE *zconfget_in  (void)
 }
 
 /** Get the output stream.
- * 
+ *
  */
 FILE *zconfget_out  (void)
 {
@@ -2148,7 +2148,7 @@ FILE *zconfget_out  (void)
 }
 
 /** Get the length of the current token.
- * 
+ *
  */
 int zconfget_leng  (void)
 {
@@ -2156,7 +2156,7 @@ int zconfget_leng  (void)
 }
 
 /** Get the current token.
- * 
+ *
  */
 
 char *zconfget_text  (void)
@@ -2166,18 +2166,18 @@ char *zconfget_text  (void)
 
 /** Set the current line number.
  * @param line_number
- * 
+ *
  */
 void zconfset_lineno (int  line_number )
 {
-    
+
     zconflineno = line_number;
 }
 
 /** Set the input stream. This does not discard the current
  * input buffer.
  * @param in_str A readable stream.
- * 
+ *
  * @see zconf_switch_to_buffer
  */
 void zconfset_in (FILE *  in_str )
@@ -2231,7 +2231,7 @@ static int yy_init_globals (void)
 /* zconflex_destroy is for both reentrant and non-reentrant scanners. */
 int zconflex_destroy  (void)
 {
-    
+
     /* Pop the buffer stack, destroying each element. */
 	while(YY_CURRENT_BUFFER){
 		zconf_delete_buffer(YY_CURRENT_BUFFER  );
-- 
1.8.5.2.192.g7794a68

