Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbaFTPrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:47:52 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33855 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754336AbaFTPrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:47:49 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2014 11:47:49 EDT
From: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
To: gregkh@linuxfoundation.org
Cc: christian.bay@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lisa@xenapiadmin.com, daeseok.youn@gmail.com, luiorpe1@gmail.com,
        veeableful@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, martin.gumbrecht@googlemail.com
Subject: [PATCH v2 5/7] Staging: bcm: Queue.h: fix checkpatch errors: whitespaces
Date: Fri, 20 Jun 2014 17:38:02 +0200
Message-Id: <1403278684-10891-6-git-send-email-martin.gumbrecht@googlemail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403278684-10891-1-git-send-email-martin.gumbrecht@googlemail.com>
References: <1403278684-10891-1-git-send-email-martin.gumbrecht@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves coding style in Queue.h
Whitespaces according to the coding guideline

Signed-off-by: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
Signed-off-by: Christian Bay <christian.bay@studium.fau.de>
---
 drivers/staging/bcm/Queue.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/bcm/Queue.h b/drivers/staging/bcm/Queue.h
index b6f8468e..460c0ae 100644
--- a/drivers/staging/bcm/Queue.h
+++ b/drivers/staging/bcm/Queue.h
@@ -6,24 +6,24 @@
 
 
 
-#define ENQUEUEPACKET(_Head, _Tail,_Packet)	\
+#define ENQUEUEPACKET(_Head, _Tail, _Packet)	\
 do {						\
-    if (!_Head) {                           \
-        	_Head = _Packet;                \
-	} 					\
-	else {                                  \
-        	(_Tail)->next = _Packet; 	\
-        }                                       \
-   	(_Packet)->next = NULL;  		\
-    _Tail = _Packet;                        \
-}while(0)
-#define DEQUEUEPACKET(Head, Tail )            	\
+	if (!_Head) {				\
+		_Head = _Packet;		\
+	}					\
+	else {					\
+		(_Tail)->next = _Packet;	\
+	}					\
+	(_Packet)->next = NULL;			\
+	_Tail = _Packet;			\
+} while (0)
+#define DEQUEUEPACKET(Head, Tail)		\
 do {						\
 	if (Head) {				\
-        if (!Head->next) {                      \
-        	Tail = NULL;                    \
-        }                                       \
-        Head = Head->next;                      \
-	}                \
+		if (!Head->next) {		\
+			Tail = NULL;		\
+		}				\
+		Head = Head->next;		\
+	}					\
 } while (0)
 #endif /* __QUEUE_H__ */
-- 
1.9.1

