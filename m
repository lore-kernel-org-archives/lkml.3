Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaJBNoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:44:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaJBNoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:44:17 -0400
From: Michal Marek <mmarek@suse.cz>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        yamada.m@jp.panasonic.com
Subject: [PATCH] IXP4xx: Makefile cleanup
Date: Thu,  2 Oct 2014 15:44:02 +0200
Message-Id: <1412257442-4362-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

obj-pci-n will never be assigned or used. obj-pci-y does not need to be
initialized, because each Kbuild file is processed separately.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 arch/arm/mach-ixp4xx/Makefile | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-ixp4xx/Makefile b/arch/arm/mach-ixp4xx/Makefile
index eded94c..2ecc4c9 100644
--- a/arch/arm/mach-ixp4xx/Makefile
+++ b/arch/arm/mach-ixp4xx/Makefile
@@ -2,9 +2,6 @@
 # Makefile for the linux kernel.
 #
 
-obj-pci-y	:=
-obj-pci-n	:=
-
 obj-pci-$(CONFIG_ARCH_IXDP4XX)		+= ixdp425-pci.o
 obj-pci-$(CONFIG_MACH_AVILA)		+= avila-pci.o
 obj-pci-$(CONFIG_MACH_IXDPG425)		+= ixdpg425-pci.o
-- 
1.8.4.5

