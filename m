Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaJSNL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 09:11:26 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47335 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaJSNLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 09:11:07 -0400
From: Chen Weixiang <weixiangchen@gmail.com>
X-Google-Original-From: Chen Weixiang <weixiang.chen@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen Weixiang <weixiang.chen@gmail.com>,
        Greg Donald <gdonald@gmail.com>, Chen Gang <gang.chen.5i5j@gmail.com>,
        Artem Fetishev <wwctrsrx@gmail.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] staging: ft1000: "(foo*)" should be "(foo *)"
Date: Sun, 19 Oct 2014 20:59:49 +0800
Message-Id: <1413723590-19690-7-git-send-email-weixiang.chen@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413723590-19690-1-git-send-email-weixiang.chen@gmail.com>
References: <1413723590-19690-1-git-send-email-weixiang.chen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove code style error from ft1000/ft1000-usb/ft1000_debug.c:
ERROR: "(foo*)" should be "(foo *)"

Signed-off-by: Chen Weixiang <weixiang.chen@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index 183128c..454dc69 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -447,7 +447,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
     switch (cmd) {
     case IOCTL_REGISTER_CMD:
             DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_REGISTER called\n");
-            result = get_user(tempword, (__u16 __user*)argp);
+            result = get_user(tempword, (__u16 __user *)argp);
             if (result) {
                 DEBUG("result = %d failed to get_user\n", result);
                 break;
@@ -652,7 +652,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
                             }
                             pmsg++;
 				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
-                           result = card_send_command(ft1000dev, (unsigned short*)dpram_data, total_len+2);
+                           result = card_send_command(ft1000dev, (unsigned short *)dpram_data, total_len+2);
 
 
                             ft1000dev->app_info[app_index].nTxMsg++;
-- 
2.1.1

