Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaJAQ4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:56:41 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:57518 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaJAQ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:56:39 -0400
From: Rahul Bedarkar <rahulbedarkar89@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matthias Beyer <mail@beyermatthias.de>, Jade Bilkey <herself@thefumon.com>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Himangi Saraogi <himangi774@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Rahul Bedarkar <rahulbedarkar89@gmail.com>
Subject: [PATCH] staging: bcm: fix sparse warning in module_param
Date: Wed,  1 Oct 2014 22:26:01 +0530
Message-Id: <1412182561-7991-1-git-send-email-rahulbedarkar89@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes sparse warning in module_param
warning: pointer targets in return differ in signedness [-Wpointer-sign]

Signed-off-by: Rahul Bedarkar <rahulbedarkar89@gmail.com>
---
 drivers/staging/bcm/InterfaceInit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
index bb61d34..9eaffd8 100644
--- a/drivers/staging/bcm/InterfaceInit.c
+++ b/drivers/staging/bcm/InterfaceInit.c
@@ -15,7 +15,7 @@ static struct usb_device_id InterfaceUsbtable[] = {
 MODULE_DEVICE_TABLE(usb, InterfaceUsbtable);
 
 static int debug = -1;
-module_param(debug, uint, 0600);
+module_param(debug, int, 0600);
 MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 
 static const u32 default_msg =
-- 
1.8.3.2

