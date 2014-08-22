Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbaHVP4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:56:48 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:46529 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338AbaHVPzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:55:24 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 06/11] ARM: multi_v7_defconfig: Enable Xilinx I2C driver
Date: Fri, 22 Aug 2014 08:54:31 -0700
Message-Id: <1408722876-7791-7-git-send-email-soren.brinkmann@xilinx.com>
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
index 5cc1c837f8cd..68a4c6b04f2b 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -207,6 +207,7 @@ CONFIG_I2C_SIRF=y
 CONFIG_I2C_TEGRA=y
 CONFIG_I2C_ST=y
 CONFIG_SPI=y
+CONFIG_I2C_XILINX=y
 CONFIG_SPI_CADENCE=y
 CONFIG_SPI_OMAP24XX=y
 CONFIG_SPI_ORION=y
-- 
2.0.1.1.gfbfc394

