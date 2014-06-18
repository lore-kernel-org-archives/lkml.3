Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbaFRORq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:17:46 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:42748 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbaFRORo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:17:44 -0400
From: Christian Bay <christian.bay@studium.fau.de>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        lisa@xenapiadmin.com, linux-kernel@i4.cs.fau.de,
        Christian Bay <christian.bay@studium.fau.de>,
        Martin Gumbrecht <martin.gumbrecht@googlemail.com>
Subject: [PATCH 2/2] Staging: bcm: Queue.h: fix checkpatch errors
Date: Wed, 18 Jun 2014 16:10:06 +0200
Message-Id: <1403100606-14881-3-git-send-email-christian.bay@studium.fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403100606-14881-1-git-send-email-christian.bay@studium.fau.de>
References: <1403100606-14881-1-git-send-email-christian.bay@studium.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all checkpatch errors and warnings in Queue.h:
Whitespaces, brackets and comments according to the coding guideline

Signed-off-by: Christian Bay <christian.bay@studium.fau.de>
Signed-off-by: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
---
 drivers/staging/bcm/Queue.h | 44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/bcm/Queue.h b/drivers/staging/bcm/Queue.h
index e1f1da2..7b4a8a8 100644
--- a/drivers/staging/bcm/Queue.h
+++ b/drivers/staging/bcm/Queue.h
@@ -1,31 +1,29 @@
 /*************************************
-* 	Queue.h
+*	Queue.h
 **************************************/
 #ifndef	__QUEUE_H__
 #define	__QUEUE_H__
 
 
 
-#define ENQUEUEPACKET(_Head, _Tail,_Packet)	\
-do						\
-{                                               \
-    if (!_Head) {                           \
-        	_Head = _Packet;                \
-        } 					\
+#define ENQUEUEPACKET(_Head, _Tail, _Packet)	\
+do {						\
+	if (!_Head) {                           \
+		_Head = _Packet;                \
+	}					\
 	else {                                  \
-        	(_Tail)->next = _Packet; 	\
-        }                                       \
-   	(_Packet)->next = NULL;  		\
-    _Tail = _Packet;                        \
-}while(0)
-#define DEQUEUEPACKET(Head, Tail )            	\
-do						\
-{   if(Head)			\
-	{                                            \
-        if (!Head->next) {                      \
-        	Tail = NULL;                    \
-        }                                       \
-        Head = Head->next;                      \
-	}		\
-}while(0)
-#endif	//__QUEUE_H__
+		(_Tail)->next = _Packet;	\
+	}                                       \
+	(_Packet)->next = NULL;			\
+	_Tail = _Packet;                        \
+} while (0)
+#define DEQUEUEPACKET(Head, Tail)		\
+do {						\
+	if (Head) {				\
+		if (!Head->next) {              \
+			Tail = NULL;            \
+		}                               \
+		Head = Head->next;              \
+	}                \
+} while (0)
+#endif /* __QUEUE_H__ */
-- 
1.9.1

