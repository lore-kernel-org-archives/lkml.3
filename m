Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaEIG6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 02:58:11 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50929 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaEIG6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 02:58:09 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH v3 2/3] ARM: sunxi: drop CONFIG_COMMON_CLK_DEBUG
Date: Fri,  9 May 2014 12:27:48 +0530
Message-Id: <1399618669-6830-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399618669-6830-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1399618669-6830-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch drops CONFIG_COMMON_CLK_DEBUG option
as this config option is now obsolete.

CC: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Olof Johansson <olof@lixom.net>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/configs/sunxi_defconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/configs/sunxi_defconfig b/arch/arm/configs/sunxi_defconfig
index b5df4a5..28287ae 100644
--- a/arch/arm/configs/sunxi_defconfig
+++ b/arch/arm/configs/sunxi_defconfig
@@ -62,7 +62,6 @@ CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGERS=y
 CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
-CONFIG_COMMON_CLK_DEBUG=y
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_TMPFS=y
 CONFIG_NFS_FS=y
-- 
1.7.9.5

