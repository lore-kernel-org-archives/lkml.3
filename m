Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946081AbaD3VG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:06:59 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:64866 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946053AbaD3VG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:06:58 -0400
From: Karim Raslan <karim.allah.ahmed@gmail.com>
Cc: Karim Raslan <karim.allah.ahmed@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        SeongJae Park <sj38.park@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        John Stultz <john.stultz@linaro.org>,
        Cruz Julian Bishop <cruzjbishop@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fixing coding style issues in android alarm-dev.c
Date: Wed, 30 Apr 2014 22:05:53 +0100
Message-Id: <1398891959-10437-1-git-send-email-karim.allah.ahmed@gmail.com>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixing "Missing a blank line after declarations" found by checkpatch.pl script

Signed-off-by: Karim Raslan <karim.allah.ahmed@gmail.com>
---
 drivers/staging/android/alarm-dev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index 2fc7cdd..f200e8a 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -329,6 +329,7 @@ static int alarm_release(struct inode *inode, struct file *file)
 	if (file->private_data) {
 		for (i = 0; i < ANDROID_ALARM_TYPE_COUNT; i++) {
 			uint32_t alarm_type_mask = 1U << i;
+
 			if (alarm_enabled & alarm_type_mask) {
 				alarm_dbg(INFO,
 					  "%s: clear alarm, pending %d\n",
-- 
1.7.9.5

