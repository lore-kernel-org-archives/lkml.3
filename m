Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3KNMPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:15:12 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38109 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3KNMPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:15:06 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 3/3] staging: alarm-dev: Seperate functions with one blank line
Date: Thu, 14 Nov 2013 21:15:12 +0900
Message-Id: <1384431312-2685-3-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384431312-2685-1-git-send-email-sj38.park@gmail.com>
References: <y>
 <1384431312-2685-1-git-send-email-sj38.park@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/android/alarm-dev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index a3b467b..2fc7cdd 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -278,6 +278,7 @@ static long alarm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	return 0;
 }
+
 #ifdef CONFIG_COMPAT
 static long alarm_compat_ioctl(struct file *file, unsigned int cmd,
 							unsigned long arg)
-- 
1.7.9.5

