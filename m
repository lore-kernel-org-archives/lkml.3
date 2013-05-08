Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab3EHRha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 13:37:30 -0400
Received: from mail-gh0-f202.google.com ([209.85.160.202]:61250 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab3EHRh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 13:37:28 -0400
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: exynos: dts: Fixed vbus-gpios
Date: Wed,  8 May 2013 10:37:16 -0700
Message-Id: <1368034636-15865-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'samsung,vbus-gpio' was submitted before pinmux landed for
exynos5250 and uses the old-style gpio specifier.  Fix the two
exynos5250 boards that use it.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/exynos5250-smdk5250.dts | 2 +-
 arch/arm/boot/dts/exynos5250-snow.dts     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 26d856b..3e0c792 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -214,7 +214,7 @@
 	};
 
 	usb@12110000 {
-		samsung,vbus-gpio = <&gpx2 6 1 3 3>;
+		samsung,vbus-gpio = <&gpx2 6 0>;
 	};
 
 	dp-controller {
diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
index bf4744b..d449feb 100644
--- a/arch/arm/boot/dts/exynos5250-snow.dts
+++ b/arch/arm/boot/dts/exynos5250-snow.dts
@@ -183,7 +183,7 @@
 	};
 
 	usb@12110000 {
-		samsung,vbus-gpio = <&gpx1 1 1 3 3>;
+		samsung,vbus-gpio = <&gpx1 1 0>;
 	};
 
 	fixed-rate-clocks {
-- 
1.8.2.1

