Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaBGNYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:24:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41427 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbaBGLry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:47:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Abhilash Kesavan <a.kesavan@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 012/233] ARM: dts: exynos5250: Fix MDMA0 clock number
Date: Fri,  7 Feb 2014 11:43:51 +0000
Message-Id: <1391773652-25214-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhilash Kesavan <a.kesavan@samsung.com>

commit 8777539479abd7b3efeb691685415dc2b057d0e0 upstream.

Due to incorrect clock specified in MDMA0 node, using MDMA0 controller
could cause system failures, due to wrong clock being controlled. This
patch fixes this by specifying correct clock.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
Acked-by: Mike Turquette <mturquette@linaro.org>
[t.figa: Corrected commit message and description.]
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/exynos5250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index ef57277..230ba1a 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -543,7 +543,7 @@
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x10800000 0x1000>;
 			interrupts = <0 33 0>;
-			clocks = <&clock 271>;
+			clocks = <&clock 346>;
 			clock-names = "apb_pclk";
 			#dma-cells = <1>;
 			#dma-channels = <8>;
-- 
1.8.3.2

