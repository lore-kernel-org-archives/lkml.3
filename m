Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3FEKGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 06:06:48 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:39377 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3FEKGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 06:06:47 -0400
MIME-Version: 1.0
Date: Wed, 5 Jun 2013 18:06:46 +0800
Message-ID: <CAPgLHd9qUF6pcORJX264ej9J722NcNBYGiRXeVi6RUK6WgJ_qA@mail.gmail.com>
Subject: [PATCH -next] staging: octeon-usb: remove duplicated include from octeon-hcd.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, aaro.koskinen@iki.fi
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/octeon-usb/octeon-hcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
index b78bd19..39dc13d 100644
--- a/drivers/staging/octeon-usb/octeon-hcd.c
+++ b/drivers/staging/octeon-usb/octeon-hcd.c
@@ -11,7 +11,6 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <linux/platform_device.h>
 #include <linux/usb.h>
 
 #include <asm/time.h>

