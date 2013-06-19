Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934951Ab3FSRxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:53:36 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:38147 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934815Ab3FSRxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:53:34 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 2/2] arm: multi_v7_defconfig: Enable initrd/initramfs support
Date: Wed, 19 Jun 2013 10:53:04 -0700
Message-Id: <1371664384-24974-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1371664384-24974-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1371664384-24974-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_BLK_DEV_INITRD to the defconfig to support
initramfs and initrd.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index d5f0d76..2deda6d 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -83,3 +83,4 @@ CONFIG_DMADEVICES=y
 CONFIG_PL330_DMA=y
 CONFIG_SIRF_DMA=y
 CONFIG_DW_DMAC=y
+CONFIG_BLK_DEV_INITRD=y
-- 
1.8.3.1

