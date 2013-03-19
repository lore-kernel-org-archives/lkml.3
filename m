Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab3CSP6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:58:50 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:54528 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932540Ab3CSP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:58:49 -0400
Message-ID: <1363708727.1390.16.camel@x61.thuisdomein>
Subject: [PATCH] sparc: remove unused "config BITS"
From: Paul Bolle <pebolle@tiscali.nl>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 16:58:47 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Mar 2013 15:58:47.0216 (UTC) FILETIME=[A3DF4B00:01CE24BA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparc's asm/module.h got removed in commit
786d35d45cc40b2a51a18f73e14e135d47fdced7 ("Make most arch asm/module.h
files use asm-generic/module.h"). That removed the only two uses of this
Kconfig symbol. So we can remove its entry too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Eyeball tested.

 arch/sparc/Kconfig | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 289127d..991abb2 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -84,12 +84,6 @@ config ARCH_DEFCONFIG
 	default "arch/sparc/configs/sparc32_defconfig" if SPARC32
 	default "arch/sparc/configs/sparc64_defconfig" if SPARC64
 
-# CONFIG_BITS can be used at source level to get 32/64 bits
-config BITS
-	int
-	default 32 if SPARC32
-	default 64 if SPARC64
-
 config IOMMU_HELPER
 	bool
 	default y if SPARC64
-- 
1.7.11.7

