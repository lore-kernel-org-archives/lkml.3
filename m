Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaIJKUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:20:55 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35328 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaIJKU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:20:27 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Andreas Faerber <afaerber@suse.de>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 6/7] ARM: dts: Set i2c7 clock at 400kHz for Peach boards
Date: Wed, 10 Sep 2014 12:19:50 +0200
Message-Id: <1410344391-5675-7-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410344391-5675-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1410344391-5675-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The downstream ChromeOS 3.8 kernel sets the clock frequency
for the I2C bus 7 at 400kHz. Do the same change in mainline.

Suggested-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 1 +
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index b8fea56..f247709 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -489,6 +489,7 @@
 
 &hsi2c_7 {
 	status = "okay";
+	clock-frequency = <400000>;
 
 	max98090: codec@10 {
 		compatible = "maxim,max98090";
diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index 17537f0..88b3544 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -487,6 +487,7 @@
 
 &hsi2c_7 {
 	status = "okay";
+	clock-frequency = <400000>;
 
 	max98091: codec@10 {
 		compatible = "maxim,max98091";
-- 
2.1.0

