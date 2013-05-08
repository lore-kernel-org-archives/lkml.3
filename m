Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3EHRc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 13:32:59 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:42213 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324Ab3EHRc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 13:32:57 -0400
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: exynos: Select PINCTRL_EXYNOS for exynos5
Date: Wed,  8 May 2013 10:32:29 -0700
Message-Id: <1368034349-15091-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you've got MACH_EXYNOS5_DT but not MACH_EXYNOS4_DT you'll be
missing the pincontrol definitions.  Add them for exynos5.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/mach-exynos/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 6e77432..cdcd7fa 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -428,6 +428,8 @@ config MACH_EXYNOS5_DT
 	depends on ARCH_EXYNOS5
 	select ARM_AMBA
 	select CLKSRC_OF
+	select PINCTRL
+	select PINCTRL_EXYNOS
 	select USB_ARCH_HAS_XHCI
 	select USE_OF
 	help
-- 
1.8.2.1

