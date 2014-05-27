Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaE0Pgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:36:40 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36679 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaE0Pgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:36:35 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 03/15] staging: rtl8188eu:Remove unused macro _init_queue()
Date: Tue, 27 May 2014 21:05:43 +0530
Message-Id: <1401204955-4093-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
References: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8712/osdep_service.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 09e1561..66ed7f1 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -52,12 +52,6 @@ struct	__queue	{
 #define thread_exit() complete_and_exit(NULL, 0)
 #define _workitem struct work_struct
 
-#define _init_queue(pqueue)				\
-	do {						\
-		_init_listhead(&((pqueue)->queue));	\
-		spin_lock_init(&((pqueue)->lock));	\
-	} while (0)
-
 static inline struct list_head *get_next(struct list_head *list)
 {
 	return list->next;
-- 
1.7.10.4

