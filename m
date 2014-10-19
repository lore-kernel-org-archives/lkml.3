Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaJSNLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 09:11:12 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:57795 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaJSNKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 09:10:50 -0400
From: Chen Weixiang <weixiangchen@gmail.com>
X-Google-Original-From: Chen Weixiang <weixiang.chen@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen Weixiang <weixiang.chen@gmail.com>,
        Greg Donald <gdonald@gmail.com>, Chen Gang <gang.chen.5i5j@gmail.com>,
        Artem Fetishev <wwctrsrx@gmail.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] staging: ft1000: do not initialise statics to 0 or NULL
Date: Sun, 19 Oct 2014 20:59:44 +0800
Message-Id: <1413723590-19690-2-git-send-email-weixiang.chen@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413723590-19690-1-git-send-email-weixiang.chen@gmail.com>
References: <1413723590-19690-1-git-send-email-weixiang.chen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove following checkpatch.pl error from ft1000/ft1000-usb/ft1000_debug.c
ERROR: do not initialise statics to 0 or NULL

Signed-off-by: Chen Weixiang <weixiang.chen@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index 0f347ab..2573147 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -38,7 +38,7 @@
 #include <linux/debugfs.h>
 #include "ft1000_usb.h"
 
-static int ft1000_flarion_cnt = 0;
+static int ft1000_flarion_cnt;
 
 static int ft1000_open(struct inode *inode, struct file *file);
 static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait);
-- 
2.1.1

