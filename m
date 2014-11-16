Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaKPNZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 08:25:39 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:51463 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaKPNZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 08:25:37 -0500
From: sunwxg <sun.wxg@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, devel@driverdev.osuosl.org
Cc: Sun Wang <sun.wxg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] staging:lustre:lnet:lnet Function must be static
Date: Sun, 16 Nov 2014 21:24:44 +0800
Message-Id: <1416144284-31138-2-git-send-email-sun.wxg@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sun Wang <sun.wxg@gmail.com>

Function must be static if function will not be used in other files.

Signed-off-by: Sun Wang <sun.wxg@gmail.com>

---
 drivers/staging/lustre/lnet/lnet/{module.c.org => module.c} | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/lnet/module.c.org b/drivers/staging/lustre/lnet/lnet/module.c
index e84d59d..4ca7b1d 100644
--- a/drivers/staging/lustre/lnet/lnet/module.c.org
+++ b/drivers/staging/lustre/lnet/lnet/module.c
@@ -43,7 +43,7 @@ MODULE_PARM_DESC(config_on_load, "configure network at module load");
 
 static struct mutex lnet_config_mutex;
 
-int
+static int
 lnet_configure(void *arg)
 {
 	/* 'arg' only there so I can be passed to cfs_create_thread() */
