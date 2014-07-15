Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbaGORZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:25:59 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60517 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbaGORCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:08 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 22/94] ARM: dts: fix pwm-cells in pwm node for exynos4
Date: Tue, 15 Jul 2014 20:00:37 +0300
Message-Id: <1405443709-15288-22-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaewon Kim <jaewon02.kim@samsung.com>

pwm-cells should be 3. Third cell is optional PWM flags. And This flag
supported by this binding is PWM_POLARITY_INVERTED.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Reviewed-by: Sachin Kamat <sachin.kamat@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/boot/dts/exynos4.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index fbaf426..17b22e9 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -554,7 +554,7 @@
 		interrupts = <0 37 0>, <0 38 0>, <0 39 0>, <0 40 0>, <0 41 0>;
 		clocks = <&clock CLK_PWM>;
 		clock-names = "timers";
-		#pwm-cells = <2>;
+		#pwm-cells = <3>;
 		status = "disabled";
 	};
 
-- 
1.7.10.4

