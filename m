Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbaFTPrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:47:53 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33865 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873AbaFTPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:47:50 -0400
From: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
To: gregkh@linuxfoundation.org
Cc: christian.bay@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lisa@xenapiadmin.com, daeseok.youn@gmail.com, luiorpe1@gmail.com,
        veeableful@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, martin.gumbrecht@googlemail.com
Subject: [PATCH v2 4/7] Staging: bcm: Queue.h: fix checkpatch errors: brackets
Date: Fri, 20 Jun 2014 17:38:01 +0200
Message-Id: <1403278684-10891-5-git-send-email-martin.gumbrecht@googlemail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403278684-10891-1-git-send-email-martin.gumbrecht@googlemail.com>
References: <1403278684-10891-1-git-send-email-martin.gumbrecht@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves coding style in Queue.h:
Brackets according to the coding guideline

Signed-off-by: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
Signed-off-by: Christian Bay <christian.bay@studium.fau.de>
---
 drivers/staging/bcm/Queue.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/bcm/Queue.h b/drivers/staging/bcm/Queue.h
index ebc7222..b6f8468e 100644
--- a/drivers/staging/bcm/Queue.h
+++ b/drivers/staging/bcm/Queue.h
@@ -7,11 +7,10 @@
 
 
 #define ENQUEUEPACKET(_Head, _Tail,_Packet)	\
-do						\
-{                                               \
+do {						\
     if (!_Head) {                           \
         	_Head = _Packet;                \
-        } 					\
+	} 					\
 	else {                                  \
         	(_Tail)->next = _Packet; 	\
         }                                       \
@@ -19,13 +18,12 @@ do						\
     _Tail = _Packet;                        \
 }while(0)
 #define DEQUEUEPACKET(Head, Tail )            	\
-do						\
-{   if(Head)			\
-	{                                            \
+do {						\
+	if (Head) {				\
         if (!Head->next) {                      \
         	Tail = NULL;                    \
         }                                       \
         Head = Head->next;                      \
-	}		\
-}while(0)
+	}                \
+} while (0)
 #endif /* __QUEUE_H__ */
-- 
1.9.1

