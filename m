Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaEAGaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:30:06 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:37556 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaEAG1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:27:38 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <b32955@freescale.com>, Marek Vasut <marex@denx.de>,
        <linux-mtd@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 03/12] ARM: keystone: add MTD_SPI_NOR (new dependency for M25P80)
Date: Wed, 30 Apr 2014 23:26:38 -0700
Message-Id: <1398925607-7482-4-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398925607-7482-1-git-send-email-computersforpeace@gmail.com>
References: <1398925607-7482-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defconfig contains the CONFIG_M25P80 symbol, which is now
dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to satisfy
the new dependency.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/configs/keystone_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/keystone_defconfig b/arch/arm/configs/keystone_defconfig
index ec9a41d50680..b3057730689f 100644
--- a/arch/arm/configs/keystone_defconfig
+++ b/arch/arm/configs/keystone_defconfig
@@ -112,6 +112,7 @@ CONFIG_MTD_PLATRAM=y
 CONFIG_MTD_M25P80=y
 CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_DAVINCI=y
+CONFIG_MTD_SPI_NOR=y
 CONFIG_MTD_UBI=y
 CONFIG_PROC_DEVICETREE=y
 CONFIG_BLK_DEV_LOOP=y
-- 
1.8.3.2

