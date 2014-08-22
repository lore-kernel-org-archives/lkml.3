Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbaHVPzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:55:55 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:37826 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbaHVPza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:55:30 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 10/11] ARM: multi_v7_defconfig: Enable Xilinx emaclite driver
Date: Fri, 22 Aug 2014 08:54:35 -0700
Message-Id: <1408722876-7791-11-git-send-email-soren.brinkmann@xilinx.com>
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
index 2aa2c5b4bd7e..ddb8a070ba6f 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -148,6 +148,7 @@ CONFIG_R8169=y
 CONFIG_SMSC911X=y
 CONFIG_STMMAC_ETH=y
 CONFIG_TI_CPSW=y
+CONFIG_XILINX_EMACLITE=y
 CONFIG_AT803X_PHY=y
 CONFIG_MARVELL_PHY=y
 CONFIG_ICPLUS_PHY=y
-- 
2.0.1.1.gfbfc394

