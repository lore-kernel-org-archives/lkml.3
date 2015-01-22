Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbbAVPqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:46:47 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:37198 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbbAVPpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:45:52 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 5/5] ARM: sunxi: dts: axp209: Use clock-frequency for DC-DC work frequency
Date: Thu, 22 Jan 2015 23:39:07 +0800
Message-Id: <1421941147-9682-6-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421941147-9682-1-git-send-email-wens@csie.org>
References: <1421941147-9682-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the axp209 dtsi to use new standard bindings for DCDC regulator
work frequency.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/axp209.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/axp209.dtsi b/arch/arm/boot/dts/axp209.dtsi
index c20cf537f5a5..ee9487583d31 100644
--- a/arch/arm/boot/dts/axp209.dtsi
+++ b/arch/arm/boot/dts/axp209.dtsi
@@ -60,7 +60,7 @@
 
 	regulators {
 		/* Default work frequency for buck regulators */
-		x-powers,dcdc-freq = <1500>;
+		clock-frequency = <1500000>;
 
 		reg_dcdc2: dcdc2 {
 			regulator-name = "dcdc2";
-- 
2.1.4

