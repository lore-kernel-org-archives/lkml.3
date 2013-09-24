Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab3IXSIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 14:08:22 -0400
Received: from mail-yh0-f73.google.com ([209.85.213.73]:38309 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3IXSHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 14:07:03 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Padmavathi Venna <padma.v@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH V3 6/6] ARM: dts: exynos5420: add input clocks to audss clock controller
Date: Tue, 24 Sep 2013 11:06:56 -0700
Message-Id: <1380046016-5811-6-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380046016-5811-1-git-send-email-abrestic@chromium.org>
References: <1379982078-23381-1-git-send-email-abrestic@chromium.org>
 <1380046016-5811-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specify the remaining input clocks (pll_ref, pll_in, and sclk_pcm_in)
for the AudioSS clock controller.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes since v1:
 - specified additional input clocks
---
 arch/arm/boot/dts/exynos5420.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index d537cd7..056b55e 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -72,8 +72,8 @@
 		compatible = "samsung,exynos5420-audss-clock";
 		reg = <0x03810000 0x0C>;
 		#clock-cells = <1>;
-		clocks = <&clock 148>;
-		clock-names = "sclk_audio";
+		clocks = <&clock 1>, <&clock 5>, <&clock 148>, <&clock 149>;
+		clock-names = "pll_ref", "pll_in", "sclk_audio", "sclk_pcm_in";
 	};
 
 	codec@11000000 {
-- 
1.8.4

