Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab3E1Trm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:47:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17927 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3E1Trl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:47:41 -0400
X-Authority-Analysis: v=2.0 cv=IZAFqBWa c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=4wbfxzRLdVAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=oOg-87CC8rEA:10 a=usS-VpU-zAEN8tql_VUA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369770459.15552.20.camel@gandalf.local.home>
Subject: [PATCH] trivial/sprintf: Fix typo of witdh to width
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 28 May 2013 15:47:39 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hex_string() had a typo in a comment.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-trace.git/lib/vsprintf.c
===================================================================
--- linux-trace.git.orig/lib/vsprintf.c
+++ linux-trace.git/lib/vsprintf.c
@@ -670,7 +670,7 @@ static noinline_for_stack
 char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
 		 const char *fmt)
 {
-	int i, len = 1;		/* if we pass '%ph[CDN]', field witdh remains
+	int i, len = 1;		/* if we pass '%ph[CDN]', field width remains
 				   negative value, fallback to the default */
 	char separator;
 


