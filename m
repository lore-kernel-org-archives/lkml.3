Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbaFTPry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:47:54 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33858 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510AbaFTPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:47:50 -0400
From: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
To: gregkh@linuxfoundation.org
Cc: christian.bay@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lisa@xenapiadmin.com, daeseok.youn@gmail.com, luiorpe1@gmail.com,
        veeableful@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, martin.gumbrecht@googlemail.com
Subject: [PATCH v2 3/7] Staging: bcm: Queue.h: fix checkpatch errors: comments
Date: Fri, 20 Jun 2014 17:38:00 +0200
Message-Id: <1403278684-10891-4-git-send-email-martin.gumbrecht@googlemail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403278684-10891-1-git-send-email-martin.gumbrecht@googlemail.com>
References: <1403278684-10891-1-git-send-email-martin.gumbrecht@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves coding style in Queue.h
Comments according to the coding guideline

Signed-off-by: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
Signed-off-by: Christian Bay <christian.bay@studium.fau.de>
---
 drivers/staging/bcm/Queue.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/bcm/Queue.h b/drivers/staging/bcm/Queue.h
index e1f1da2..ebc7222 100644
--- a/drivers/staging/bcm/Queue.h
+++ b/drivers/staging/bcm/Queue.h
@@ -1,5 +1,5 @@
 /*************************************
-* 	Queue.h
+* Queue.h
 **************************************/
 #ifndef	__QUEUE_H__
 #define	__QUEUE_H__
@@ -28,4 +28,4 @@ do						\
         Head = Head->next;                      \
 	}		\
 }while(0)
-#endif	//__QUEUE_H__
+#endif /* __QUEUE_H__ */
-- 
1.9.1

