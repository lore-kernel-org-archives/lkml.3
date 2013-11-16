Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab3KPRkE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 12:40:04 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:46233 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3KPRjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 12:39:39 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 2/5] cmdline: fix style issues
Date: Sat, 16 Nov 2013 11:32:28 -0600
Message-Id: <1384623151-31302-3-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
In-Reply-To: <1384623151-31302-1-git-send-email-felipe.contreras@gmail.com>
References: <1384623151-31302-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: space prohibited between function name and open parenthesis '('
+int get_option (char **str, int *pint)

WARNING: space prohibited between function name and open parenthesis '('
+	*pint = simple_strtol (cur, str, 0);

ERROR: trailing whitespace
+ $

WARNING: please, no spaces at the start of a line
+ $

WARNING: space prohibited between function name and open parenthesis '('
+		res = get_option ((char **)&str, ints + i);

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 lib/cmdline.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/cmdline.c b/lib/cmdline.c
index eb67911..5466333 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -49,13 +49,13 @@ static int get_range(char **str, int *pint)
  *	3 - hyphen found to denote a range
  */
 
-int get_option (char **str, int *pint)
+int get_option(char **str, int *pint)
 {
 	char *cur = *str;
 
 	if (!cur || !(*cur))
 		return 0;
-	*pint = simple_strtol (cur, str, 0);
+	*pint = simple_strtol(cur, str, 0);
 	if (cur == *str)
 		return 0;
 	if (**str == ',') {
@@ -84,13 +84,13 @@ int get_option (char **str, int *pint)
  *	the parse to end (typically a null terminator, if @str is
  *	completely parseable).
  */
- 
+
 char *get_options(const char *str, int nints, int *ints)
 {
 	int res, i = 1;
 
 	while (i < nints) {
-		res = get_option ((char **)&str, ints + i);
+		res = get_option((char **)&str, ints + i);
 		if (res == 0)
 			break;
 		if (res == 3) {
@@ -153,7 +153,6 @@ unsigned long long memparse(const char *ptr, char **retptr)
 	return ret;
 }
 
-
 EXPORT_SYMBOL(memparse);
 EXPORT_SYMBOL(get_option);
 EXPORT_SYMBOL(get_options);
-- 
1.8.4.2+fc1

