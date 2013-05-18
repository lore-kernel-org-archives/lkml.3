Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab3ERJRw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 05:17:52 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61811 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3ERJRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 05:17:50 -0400
From: Alexandre Courbot <gnurou@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] ARM: tegra: enable host1x support by default
Date: Sat, 18 May 2013 18:17:46 +0900
Message-Id: <1368868666-24754-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra DRM support used to be enabled in the default Tegra configuration,
but it now depends on CONFIG_TEGRA_HOST1X which is disabled by default.
Enable CONFIG_TEGRA_HOST1X so that DRM support is compiled in again.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/configs/tegra_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index a5f0485..dbf83db 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -153,6 +153,7 @@ CONFIG_MEDIA_CAMERA_SUPPORT=y
 CONFIG_MEDIA_USB_SUPPORT=y
 CONFIG_USB_VIDEO_CLASS=m
 CONFIG_DRM=y
+CONFIG_TEGRA_HOST1X=y
 CONFIG_DRM_TEGRA=y
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
 # CONFIG_LCD_CLASS_DEVICE is not set
-- 
1.8.2.3

