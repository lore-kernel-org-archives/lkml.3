Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965128Ab3BNNtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:49:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934317Ab3BNNtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:49:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-sh@vger.kernel.org
Subject: [PATCH 04/11] ARM: shmobile: fix defconfig warning on CONFIG_USB
Date: Thu, 14 Feb 2013 14:49:20 +0100
Message-Id: <1360849767-1463135-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:wtDVvP4J1q7B4jUgUT7D+OC8Ru8gKfWmlAFfNM11GPa
 f3DhCaNMqJd31EgMmpa/D6xe30WmcHXz4wFpomeu5mCsek+PUZ
 BfXPiIyZIMMoqNULfgDNQPBrHdfDOkLFv5BSEBNzjT+6tnJopp
 1m7Sm+FbznkyxKKqVeTrPa1UEz4nGaV0ejR34mIcyjpnkROHKY
 YolmwJXJAxcR/8HXihsJVTGXyDq69z2twuNjjbOyngYFyYxLY1
 /v68qh3KQPpqFL804/afey9srNbZKQMV5wPORgF9AhaQBM6gqV
 Uc/u49YYPt59Hgzp+F5ToiYVFSir4C2uIaxt2DkgRWonwrfPtY
 PDhHq6CJcZKvF2mh6/ETCzRcAEBz37RwJIw8pJxOg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent update to the marzen_defconfig introduced a
duplicate CONFIG_USB=y line. This removes one of the
two.

arch/arm/configs/marzen_defconfig:86:warning: override: reassigning to symbol USB

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Simon Horman <horms+renesas@verge.net.au>
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
1.8.1.2

