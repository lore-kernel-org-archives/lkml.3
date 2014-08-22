Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbaHVPzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:55:37 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:38817 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221AbaHVPzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:55:32 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 11/11] ARM: multi_v7_defconfig: Enable Xilinx watchdog timer
Date: Fri, 22 Aug 2014 08:54:36 -0700
Message-Id: <1408722876-7791-12-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
In-Reply-To: <1408722876-7791-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1408722876-7791-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index ddb8a070ba6f..7105f06f8dfb 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -245,6 +245,7 @@ CONFIG_ARMADA_THERMAL=y
 CONFIG_ST_THERMAL_SYSCFG=y
 CONFIG_ST_THERMAL_MEMMAP=y
 CONFIG_WATCHDOG=y
+CONFIG_XILINX_WATCHDOG=y
 CONFIG_ORION_WATCHDOG=y
 CONFIG_SUNXI_WATCHDOG=y
 CONFIG_MFD_AS3722=y
-- 
2.0.1.1.gfbfc394

