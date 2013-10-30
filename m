Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab3J3FiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 01:38:20 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:61008 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3J3FiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 01:38:19 -0400
MIME-Version: 1.0
Date: Wed, 30 Oct 2013 13:38:18 +0800
Message-ID: <CAPgLHd9U4t3K4ziGQub9fat6Wqwj2PXh0O+DDYFNnf7r5eB_2Q@mail.gmail.com>
Subject: [PATCH -next] ARM: ixp4xx: remove duplicated include from dsmg600-setup.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kaloz@openwrt.org, khc@pm.waw.pl, linux@arm.linux.org.uk
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/mach-ixp4xx/dsmg600-setup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-ixp4xx/dsmg600-setup.c b/arch/arm/mach-ixp4xx/dsmg600-setup.c
index 736dc69..7740e13 100644
--- a/arch/arm/mach-ixp4xx/dsmg600-setup.c
+++ b/arch/arm/mach-ixp4xx/dsmg600-setup.c
@@ -26,7 +26,6 @@
 #include <linux/reboot.h>
 #include <linux/i2c.h>
 #include <linux/i2c-gpio.h>
-#include <linux/gpio.h>
 
 #include <mach/hardware.h>
 

