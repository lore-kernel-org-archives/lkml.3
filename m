Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaAJIVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 03:21:53 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:45472 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaAJIVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 03:21:51 -0500
From: Sergei Trofimovich <slyfox@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Sergei Trofimovich <slyfox@gentoo.org>, Mark Jackson <mpfj@mimc.co.uk>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] arch/avr32/boards/mimc200/fram.c: add missing 'module.h' for MODULE_LICENSE
Date: Fri, 10 Jan 2014 11:16:14 +0300
Message-Id: <1389341774-6589-1-git-send-email-slyfox@gentoo.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

config: make ARCH=avr32 mimc200_defconfig

> All error/warnings:
>
>    arch/avr32/boards/mimc200/fram.c:79: error: expected declaration specifiers or '...' before string constant
>    arch/avr32/boards/mimc200/fram.c:79: warning: data definition has no type or storage class
>    arch/avr32/boards/mimc200/fram.c:79: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
> >> arch/avr32/boards/mimc200/fram.c:79: error: function declaration isn't a prototype

Untested.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
CC: Mark Jackson <mpfj@mimc.co.uk>
CC: Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 arch/avr32/boards/mimc200/fram.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/avr32/boards/mimc200/fram.c b/arch/avr32/boards/mimc200/fram.c
index 9764a1a..76cb51d 100644
--- a/arch/avr32/boards/mimc200/fram.c
+++ b/arch/avr32/boards/mimc200/fram.c
@@ -13,6 +13,7 @@
 #include <linux/miscdevice.h>
 #include <linux/proc_fs.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/io.h>
 
 #define FRAM_BASE	0xac000000
-- 
1.8.5.2

