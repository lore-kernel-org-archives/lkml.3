Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbbAGXgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:36:23 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:62434 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbbAGXgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:36:21 -0500
From: Fabio Estevam <festevam@gmail.com>
To: shawn.guo@linaro.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] ARM: imx_v6_v7_defconfig: Select CONFIG_FB_MXS
Date: Wed,  7 Jan 2015 21:35:54 -0200
Message-Id: <1420673754-6645-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

CONFIG_FB_MXS is the LCD driver for mx6solo-lite and mx6solox.

Enable it by default.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/arm/configs/imx_v6_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index 9575af8..1f36977 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -203,6 +203,7 @@ CONFIG_DRM_PANEL_SIMPLE=y
 CONFIG_LCD_CLASS_DEVICE=y
 CONFIG_LCD_L4F00242T03=y
 CONFIG_LCD_PLATFORM=y
+CONFIG_FB_MXS=y
 CONFIG_BACKLIGHT_PWM=y
 CONFIG_BACKLIGHT_GPIO=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
-- 
1.9.1

