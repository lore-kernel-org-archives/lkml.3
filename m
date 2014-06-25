Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaFYCxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 22:53:44 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:47487 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaFYCxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 22:53:41 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 8/8] staging: rtl8712: remove inapplicable comment
Date: Tue, 24 Jun 2014 22:52:41 -0400
Message-Id: <1403664761-15728-8-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403664761-15728-7-git-send-email-shack@linux.com>
References: <1403664761-15728-1-git-send-email-shack@linux.com>
 <1403664761-15728-2-git-send-email-shack@linux.com>
 <1403664761-15728-3-git-send-email-shack@linux.com>
 <1403664761-15728-4-git-send-email-shack@linux.com>
 <1403664761-15728-5-git-send-email-shack@linux.com>
 <1403664761-15728-6-git-send-email-shack@linux.com>
 <1403664761-15728-7-git-send-email-shack@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/rtl8712/osdep_service.h |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 77b1443..3dfc473 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -95,11 +95,6 @@ static inline void _set_workitem(_workitem *pwork)
 	#define BIT(x)	(1 << (x))
 #endif
 
-/*
-For the following list_xxx operations,
-caller must guarantee the atomic context.
-Otherwise, there will be racing condition.
-*/
 static inline u32 _down_sema(struct semaphore *sema)
 {
 	if (down_interruptible(sema))
-- 
1.7.9.5

