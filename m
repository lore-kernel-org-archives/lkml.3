Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3IYVNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:13:46 -0400
Received: from mail-ye0-f202.google.com ([209.85.213.202]:55714 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab3IYVM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:12:57 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-samsung-soc@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>
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
        Tushar Behera <tushar.behera@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Padmavathi Venna <padma.v@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH V4 4/6] ARM: dts: exynos5250: add input clocks to audss clock controller
Date: Wed, 25 Sep 2013 14:12:50 -0700
Message-Id: <1380143572-11741-4-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380143572-11741-1-git-send-email-abrestic@chromium.org>
References: <1380046016-5811-1-git-send-email-abrestic@chromium.org>
 <1380143572-11741-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specify pll_ref, pll_in, sclk_audio, and sclk_pcm_in for the AudioSS
clock controller.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes since v1:
 - specified additional input clocks
---
 arch/arm/boot/dts/exynos5250.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 7d7cc77..2d6a93d 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -88,6 +88,8 @@
 		compatible = "samsung,exynos5250-audss-clock";
 		reg = <0x03810000 0x0C>;
 		#clock-cells = <1>;
+		clocks = <&clock 1>, <&clock 7>, <&clock 138>, <&clock 160>;
+		clock-names = "pll_ref", "pll_in", "sclk_audio", "sclk_pcm_in";
 	};
 
 	timer {
-- 
1.8.4

