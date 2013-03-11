Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3CKXSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:18:34 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:38797 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3CKXSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:18:31 -0400
From: Fabio Estevam <festevam@gmail.com>
To: zbr@ioremap.net
Cc: gregkh@linuxfoundation.org, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/2] ARM: imx_v6_v7_defconfig: Select CONFIG_W1_MASTER_MXC
Date: Mon, 11 Mar 2013 20:18:16 -0300
Message-Id: <1363043896-16140-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363043896-16140-1-git-send-email-festevam@gmail.com>
References: <1363043896-16140-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Select CONFIG_W1_MASTER_MXC.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/arm/configs/imx_v6_v7_defconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index e36b010..50f9a7f 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -143,6 +143,8 @@ CONFIG_SPI=y
 CONFIG_SPI_IMX=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_MC9S08DZ60=y
+CONFIG_W1=y
+CONFIG_W1_MASTER_MXC=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
 CONFIG_IMX2_WDT=y
-- 
1.7.9.5

