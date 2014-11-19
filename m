Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbaKSP4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:56:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822AbaKSP4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:56:08 -0500
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/4] ARM: exynos_defconfig: Enable LM90 driver
Date: Wed, 19 Nov 2014 16:56:23 +0100
Message-Id: <1416412585-10809-4-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1416412585-10809-1-git-send-email-afaerber@suse.de>
References: <1416412585-10809-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

multi_v7_defconfig has it as Y already, so build it in here, too, for
consistency, and therefore build in HWMON as well.

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 arch/arm/configs/exynos_defconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index 8dfa7d312f51..2d7d2027aeb9 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -84,7 +84,8 @@ CONFIG_DEBUG_GPIO=y
 CONFIG_POWER_SUPPLY=y
 CONFIG_BATTERY_SBS=y
 CONFIG_CHARGER_TPS65090=y
-# CONFIG_HWMON is not set
+CONFIG_HWMON=y
+CONFIG_SENSORS_LM90=y
 CONFIG_THERMAL=y
 CONFIG_EXYNOS_THERMAL=y
 CONFIG_EXYNOS_THERMAL_CORE=y
-- 
2.1.2

