Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab3AYWp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:45:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52779 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3AYWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:45:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 16/19] ARM: sa1100: don't warn about mach/ide.h
Date: Fri, 25 Jan 2013 22:44:15 +0000
Message-Id: <1359153858-31992-17-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ihSp1VcNwVuK3fhyKn64BY9/oy5DplMsjczVgAaXNS+
 rmmbzzCyjrejxELmifAqgxljfdOUCOO+KTlSzBcewxeqOVMXnj
 x5SHibUrXJsXWaeqvimbY06uDxW8trvI+1FtGk+1TrHvhKY9ig
 ZzOrGUM4j+D3ozsHJHwPiSFjWm9eGSWOEVLI0HdFc3v5zpJbaM
 vNfRf9XfMSTVypJ0+2T0ZHDH8DM/8p9A/MlXho8VTrbWzwlWNU
 hdVBTIHA51GZ6+Xjra0cY5vcOhzqZKS9ItUzD5+OssNBGnj/ii
 +C6MqxlCL8SbYZXk8j3EBoOMkGwGrU1UgPXxbbz2fdMiFkV50J
 FtAJwpbTCUTNdLaMhGOE/ZhhOPxY96gx/o3ZR41G4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This warning has existed since before the start of (git) history.
Apparently nobody has bothered to fix it in a long time, and
this is unlikely to change. Note that the file that the warning
refers to has moved to a different location and was subsequently
deleted in 2008.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-sa1100/lart.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-sa1100/lart.c b/arch/arm/mach-sa1100/lart.c
index f69f78f..bca7e60 100644
--- a/arch/arm/mach-sa1100/lart.c
+++ b/arch/arm/mach-sa1100/lart.c
@@ -24,9 +24,6 @@
 
 #include "generic.h"
 
-
-#warning "include/asm/arch-sa1100/ide.h needs fixing for lart"
-
 static struct mcp_plat_data lart_mcp_data = {
 	.mccr0		= MCCR0_ADM,
 	.sclk_rate	= 11981000,
-- 
1.8.0

