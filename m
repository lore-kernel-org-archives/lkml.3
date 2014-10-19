Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaJSNLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 09:11:17 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44340 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaJSNK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 09:10:58 -0400
From: Chen Weixiang <weixiangchen@gmail.com>
X-Google-Original-From: Chen Weixiang <weixiang.chen@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen Weixiang <weixiang.chen@gmail.com>,
        Greg Donald <gdonald@gmail.com>, Chen Gang <gang.chen.5i5j@gmail.com>,
        Artem Fetishev <wwctrsrx@gmail.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] staging: ft1000: space required after that ','
Date: Sun, 19 Oct 2014 20:59:46 +0800
Message-Id: <1413723590-19690-4-git-send-email-weixiang.chen@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413723590-19690-1-git-send-email-weixiang.chen@gmail.com>
References: <1413723590-19690-1-git-send-email-weixiang.chen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove code style error from ft1000/ft1000-usb/ft1000_debug.c:
ERROR: space required after that ',' (ctx:VxV)

Signed-off-by: Chen Weixiang <weixiang.chen@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index 47dc0c0..183128c 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -301,7 +301,7 @@ static int ft1000_open(struct inode *inode, struct file *file)
 {
 	struct ft1000_info *info;
 	struct ft1000_usb *dev = (struct ft1000_usb *)inode->i_private;
-    int i,num;
+    int i, num;
 
     DEBUG("%s called\n", __func__);
     num = (MINOR(inode->i_rdev) & 0xf);
@@ -419,12 +419,12 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
     struct timeval tv;
 	struct IOCTL_GET_VER get_ver_data;
 	struct IOCTL_GET_DSP_STAT get_stat_data;
-    u8 ConnectionMsg[] = {0x00,0x44,0x10,0x20,0x80,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x93,0x64,
-                          0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x0a,
-                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x12,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-                          0x00,0x00,0x02,0x37,0x00,0x00,0x00,0x08,0x00,0x00,0x00,0x01,0x00,0x01,0x7f,0x00,
-                          0x00,0x01,0x00,0x00};
+    u8 ConnectionMsg[] = {0x00, 0x44, 0x10, 0x20, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x93, 0x64,
+                          0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x0a,
+                          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+                          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+                          0x00, 0x00, 0x02, 0x37, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x7f, 0x00,
+                          0x00, 0x01, 0x00, 0x00};
 
     unsigned short ledStat = 0;
     unsigned short conStat = 0;
@@ -475,7 +475,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
             break;
         }
 
-        DEBUG("FT1000:ft1000_ioctl:driver version = 0x%x\n",(unsigned int)get_ver_data.drv_ver);
+        DEBUG("FT1000:ft1000_ioctl:driver version = 0x%x\n", (unsigned int)get_ver_data.drv_ver);
 
         break;
     case IOCTL_CONNECT:
@@ -652,7 +652,7 @@ static long ft1000_ioctl(struct file *file, unsigned int command,
                             }
                             pmsg++;
 				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
-                           result = card_send_command(ft1000dev,(unsigned short*)dpram_data,total_len+2);
+                           result = card_send_command(ft1000dev, (unsigned short*)dpram_data, total_len+2);
 
 
                             ft1000dev->app_info[app_index].nTxMsg++;
-- 
2.1.1

