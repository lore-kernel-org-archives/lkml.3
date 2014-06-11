Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbaFKI71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:59:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56408 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610AbaFKI7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:59:24 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 36/36] ARM: OMAP2+: defconfig: Enable TI GPMC driver
Date: Wed, 11 Jun 2014 11:56:41 +0300
Message-ID: <1402477001-31132-37-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for NAND and OneNAND to work.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/configs/omap2plus_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index a4e8d01..98dad6c 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -79,6 +79,8 @@ CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_DMA_CMA=y
 CONFIG_OMAP_OCP2SCP=y
 CONFIG_CONNECTOR=y
+CONFIG_MEMORY=y
+CONFIG_TI_GPMC=y
 CONFIG_MTD=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_BLOCK=y
-- 
1.8.3.2

