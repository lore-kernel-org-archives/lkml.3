Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaLRSpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 13:45:39 -0500
Received: from mail-pa0-f66.google.com ([209.85.220.66]:39239 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaLRSpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 13:45:38 -0500
Message-ID: <1418928322.6387.4.camel@hari-laptop>
Subject: Subject: [PATCH] Staging: ft1000: ft1000_hw.c:  replaced asm header
 includes with linux headers
From: Hariharan Rangasamy <hariharanrangasamy@gmail.com>
To: marek.belisko@gmail.com, gregkh@linuxfoundations.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Fri, 19 Dec 2014 00:15:22 +0530
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


used #include <linux/io.h> instead of <asm/io.h>
used #include <linux/bitops.h> instead of <asm/bitops.h>

Signed-off-by: Hariharan Rangasamy <hariharanrangasamy@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index d5475b7..62cdc88 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -28,8 +28,8 @@
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/in.h>
-#include <asm/io.h>
-#include <asm/bitops.h>
+#include <linux/io.h>
+#include <linux/bitops.h>
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>




