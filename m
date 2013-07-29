Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab3G2RV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:21:28 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:51937 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab3G2RV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:21:26 -0400
From: "santosh.anbu" <asantoshking@gmail.com>
To: ericvh@gmail.com
Cc: asantosh.king@gmail.com, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net
Subject: [PATCH] Events: 9p.h: Fixed few brace coding style issues
Date: Mon, 29 Jul 2013 22:51:08 +0530
Message-Id: <1375118468-3349-1-git-send-email-asantosh.king@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "santosh.anbu" <asantosh.king@gmail.com>

Kill all the whitespaces conforming to standards

Signed-off-by: santosh.anbu <asantosh.king@gmail.com>
---
 include/trace/events/9p.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/trace/events/9p.h b/include/trace/events/9p.h
index a066636..c91a015 100644
--- a/include/trace/events/9p.h
+++ b/include/trace/events/9p.h
@@ -83,9 +83,9 @@ TRACE_EVENT(9p_client_req,
 	    TP_ARGS(clnt, type, tag),
 
 	    TP_STRUCT__entry(
-		    __field(    void *,		clnt			     )
-		    __field(	__u8,		type			     )
-		    __field(	__u32,		tag			     )
+		    __field(void *, clnt)
+		    __field(__u8, type)
+		    __field(__u32, tag)
 		    ),
 
 	    TP_fast_assign(
@@ -97,7 +97,7 @@ TRACE_EVENT(9p_client_req,
 	    TP_printk("client %lu request %s tag  %d",
 		    (long)__entry->clnt, show_9p_op(__entry->type),
 		    __entry->tag)
- );
+);
 
 TRACE_EVENT(9p_client_res,
 	    TP_PROTO(struct p9_client *clnt, int8_t type, int tag, int err),
@@ -105,10 +105,10 @@ TRACE_EVENT(9p_client_res,
 	    TP_ARGS(clnt, type, tag, err),
 
 	    TP_STRUCT__entry(
-		    __field(    void *,		clnt			     )
-		    __field(	__u8,		type			     )
-		    __field(	__u32,		tag			     )
-		    __field(	__u32,		err			     )
+		    __field(void *, clnt)
+		    __field(__u8, type)
+		    __field(__u32, tag)
+		    __field(__u32, err)
 		    ),
 
 	    TP_fast_assign(
@@ -131,10 +131,10 @@ TRACE_EVENT(9p_protocol_dump,
 	    TP_ARGS(clnt, pdu),
 
 	    TP_STRUCT__entry(
-		    __field(	void *,		clnt				)
-		    __field(	__u8,		type				)
-		    __field(	__u16,		tag				)
-		    __array(	unsigned char,	line,	P9_PROTO_DUMP_SZ	)
+		    __field(void *, clnt)
+		    __field(__u8, type)
+		    __field(__u16, tag)
+		    __array(unsigned char, line, P9_PROTO_DUMP_SZ)
 		    ),
 
 	    TP_fast_assign(
@@ -146,7 +146,7 @@ TRACE_EVENT(9p_protocol_dump,
 	    TP_printk("clnt %lu %s(tag = %d)\n%.3x: %16ph\n%.3x: %16ph\n",
 		      (unsigned long)__entry->clnt, show_9p_op(__entry->type),
 		      __entry->tag, 0, __entry->line, 16, __entry->line + 16)
- );
+);
 
 #endif /* _TRACE_9P_H */
 
-- 
1.8.1.2

