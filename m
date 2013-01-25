Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3AYWqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:46:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64213 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab3AYWpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:45:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org
Subject: [PATCH 01/19] ARM: shmobile: fix defconfig warning on CONFIG_USB
Date: Fri, 25 Jan 2013 22:44:00 +0000
Message-Id: <1359153858-31992-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Cktv6StWKAR3CUFogOdFaC167S6b4iSOBkB9cGQndfZ
 QronJlU5E8V+iJVKN9PHQobs8R1MBEeM6AGxz3+V4+YR+j1rZ7
 PXqXjeKQtuhewvloIUljjRFTWTLgHE8gYPXKJLfj/USqijDlZe
 X1FowSIsn3gfrH7uBRnLuYBLJ4M2uH730C2VJIZCuKbi2VIXKQ
 Cx8XidvU4HAdNnm0GWgeZ6XA4MSkkjUNvHY4BKAoFAgTe2b3KX
 9ihFo85gXSgK9ALPz4QisyUNGXJbfxxtw5iUImQwy62Z6HZoPa
 PJVkWXCatfvjL9L8CjVUGUwKBCfVesaEJzTZ7umvw9vXIQrAxX
 JwJ/hp5ENdHXwbApfboi0pXGx0ZtlVxdWKT/J7cuf
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

