Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaEAG1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:27:48 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36442 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbaEAG1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:27:45 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <b32955@freescale.com>, Marek Vasut <marex@denx.de>,
        <linux-mtd@lists.infradead.org>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 07/12] ARM: shmobile: add MTD_SPI_NOR (new dependency for M25P80)
Date: Wed, 30 Apr 2014 23:26:42 -0700
Message-Id: <1398925607-7482-8-git-send-email-computersforpeace@gmail.com>
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
Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/configs/shmobile_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/shmobile_defconfig b/arch/arm/configs/shmobile_defconfig
index 83b07258a385..ddfdc36be9c8 100644
--- a/arch/arm/configs/shmobile_defconfig
+++ b/arch/arm/configs/shmobile_defconfig
@@ -43,6 +43,7 @@ CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_MTD=y
 CONFIG_MTD_M25P80=y
+CONFIG_MTD_SPI_NOR=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_ATA=y
 CONFIG_SATA_RCAR=y
-- 
1.8.3.2

