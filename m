Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935371Ab3DHQvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:51:49 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:47736 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934686Ab3DHQvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:51:48 -0400
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: fix bad merge of display timing node to exynos5250-smdk5250.dts
Date: Mon,  8 Apr 2013 09:51:19 -0700
Message-Id: <1365439879-3398-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The display timing node was added:
  7ed2077 ARM: dts: Add display timing node to exynos5250-smdk5250.dts
...and looks OK there.  ...but it looks like we lost a "};" in the
merge and it no longer compiles.  Fix it.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/exynos5250-smdk5250.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 4be14df..26d856b 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -239,6 +239,7 @@
 			vback-porch = <4>;
 			vfront-porch = <4>;
 			vsync-len = <4>;
+		};
 	};
 
 	fixed-rate-clocks {
-- 
1.8.1.3

