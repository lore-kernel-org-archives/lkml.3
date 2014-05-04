Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaEDQUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:20:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbaEDPmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3.14 156/158] dt: tegra: remove non-existent clock IDs
Date: Sun,  4 May 2014 11:41:05 -0400
Message-Id: <20140504154051.204835199@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 9ef1af9ea28c23d0eaed97f7f5142788b6cf570a upstream.

The Tegra124 clock DT binding currently provides 3 clocks that don't
actually exist; 2 for NAND and one for UART5/UARTE. Delete these. While
this is technically an incompatible DT ABI change, nothing could have
used these clock IDs for anything practical, since the HW doesn't exist.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/dt-bindings/clock/tegra124-car.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/dt-bindings/clock/tegra124-car.h
+++ b/include/dt-bindings/clock/tegra124-car.h
@@ -29,7 +29,7 @@
 /* 10 (register bit affects spdif_in and spdif_out) */
 #define TEGRA124_CLK_I2S1 11
 #define TEGRA124_CLK_I2C1 12
-#define TEGRA124_CLK_NDFLASH 13
+/* 13 */
 #define TEGRA124_CLK_SDMMC1 14
 #define TEGRA124_CLK_SDMMC4 15
 /* 16 */
@@ -83,7 +83,7 @@
 
 /* 64 */
 #define TEGRA124_CLK_UARTD 65
-#define TEGRA124_CLK_UARTE 66
+/* 66 */
 #define TEGRA124_CLK_I2C3 67
 #define TEGRA124_CLK_SBC4 68
 #define TEGRA124_CLK_SDMMC3 69
@@ -97,7 +97,7 @@
 #define TEGRA124_CLK_TRACE 77
 #define TEGRA124_CLK_SOC_THERM 78
 #define TEGRA124_CLK_DTV 79
-#define TEGRA124_CLK_NDSPEED 80
+/* 80 */
 #define TEGRA124_CLK_I2CSLOW 81
 #define TEGRA124_CLK_DSIB 82
 #define TEGRA124_CLK_TSEC 83


