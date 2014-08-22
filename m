Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbaHVP5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:57:54 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:65213 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaHVPzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:55:11 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 02/11] ARM: multi_v7_defconfig: Enable Zynq/Xilinx CAN driver
Date: Fri, 22 Aug 2014 08:54:27 -0700
Message-Id: <1408722876-7791-3-git-send-email-soren.brinkmann@xilinx.com>
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
index 4c248348411c..50a5f8197fab 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -107,6 +107,7 @@ CONFIG_CAN=y
 CONFIG_CAN_RAW=y
 CONFIG_CAN_BCM=y
 CONFIG_CAN_DEV=y
+CONFIG_CAN_XILINXCAN=y
 CONFIG_CAN_MCP251X=y
 CONFIG_CFG80211=m
 CONFIG_MAC80211=m
-- 
2.0.1.1.gfbfc394

