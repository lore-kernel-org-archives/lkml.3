Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbaHVPzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:55:13 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63229 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190AbaHVPzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:55:09 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 01/11] ARM: multi_v7_defconfig: Enable Zynq cpuidle driver
Date: Fri, 22 Aug 2014 08:54:26 -0700
Message-Id: <1408722876-7791-2-git-send-email-soren.brinkmann@xilinx.com>
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
index 5fb95fb758d9..4c248348411c 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -86,6 +86,7 @@ CONFIG_CPU_FREQ_STAT_DETAILS=y
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_IDLE=y
 CONFIG_NEON=y
+CONFIG_ARM_ZYNQ_CPUIDLE=y
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
-- 
2.0.1.1.gfbfc394

