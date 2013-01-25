Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab3AYOPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:15:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:65390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098Ab3AYOOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:14:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org
Subject: [PATCH 01/19] ARM: shmobile: fix defconfig warning on CONFIG_USB
Date: Fri, 25 Jan 2013 14:14:18 +0000
Message-Id: <1359123276-15833-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359123276-15833-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:9ZjXBDASeVLmG5Bjx1tqGdKMyPEz6kgDUYP5/ar4zVy
 z7jZgiUKPm4XCrGkZIa2mw62ILiQENau1kog8Zi4/ETsskIeIL
 YSYS201t1sG137CPxqXqNUMkhHCxjDIDzLTMY5rQsbQbANyOJx
 dY9Nfbenvf95c9SL1o91bGn70/wjCnLL5AaVLfecVBeHoC/pln
 hVaCbw2AsLjUecp1tDSt/w2nBOsTMMHseTiL3++nBo/zBflJFC
 Ih6Al6KitbwniecN+YsX8ijKJl3LixMzEsOHvkzh0drZX8CsFT
 WtSLn39+ZvgZ0pBMthw8p0LVd6at2gvZSLNC52UKf5VZ/iyZ3W
 fCmNxxdfGObmXAKBKlMwSgRH4HbQuwFJHNVphUvpI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent update to the marzen_defconfig introduced a
duplicate CONFIG_USB=y line. This removes one of the
two.

arch/arm/configs/marzen_defconfig:86:warning: override: reassigning to symbol USB

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Simon Horman <horms@verge.net.au>
Cc: linux-sh@vger.kernel.org
---
 arch/arm/configs/marzen_defconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/configs/marzen_defconfig b/arch/arm/configs/marzen_defconfig
index 728a43c..afb17d6 100644
--- a/arch/arm/configs/marzen_defconfig
+++ b/arch/arm/configs/marzen_defconfig
@@ -83,7 +83,6 @@ CONFIG_USB=y
 CONFIG_USB_RCAR_PHY=y
 CONFIG_MMC=y
 CONFIG_MMC_SDHI=y
-CONFIG_USB=y
 CONFIG_USB_EHCI_HCD=y
 CONFIG_USB_OHCI_HCD=y
 CONFIG_USB_OHCI_HCD_PLATFORM=y
-- 
1.8.0

