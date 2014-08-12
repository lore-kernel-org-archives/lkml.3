Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaHLQpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:45:24 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38300 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbaHLQpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:45:19 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 6/6] ARM: dts: Add tps65090 FETs constraints
Date: Tue, 12 Aug 2014 18:44:28 +0200
Message-Id: <1407861868-20097-7-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tps65090 PMU data manual [0] has a table that list the
"Recommended operating conditions" for each regulator. Add
the information about the FET constraints to its dtsi file.

[0]: http://www.ti.com/lit/ds/symlink/tps65090.pdf

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/tps65090.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/tps65090.dtsi b/arch/arm/boot/dts/tps65090.dtsi
index a2ff534..60c56da 100644
--- a/arch/arm/boot/dts/tps65090.dtsi
+++ b/arch/arm/boot/dts/tps65090.dtsi
@@ -24,30 +24,48 @@
 		};
 
 		tps65090_fet1: fet1 {
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <17000000>;
 		};
 
 		tps65090_fet2: fet2 {
+			regulator-min-microvolt = <4500000>;
+			regulator-max-microvolt = <5500000>;
 		};
 
 		tps65090_fet3: fet3 {
+			regulator-min-microvolt = <3000000>;
+			regulator-max-microvolt = <5500000>;
 		};
 
 		tps65090_fet4: fet4 {
+			regulator-min-microvolt = <3000000>;
+			regulator-max-microvolt = <5500000>;
 		};
 
 		tps65090_fet5: fet5 {
+			regulator-min-microvolt = <3000000>;
+			regulator-max-microvolt = <5500000>;
 		};
 
 		tps65090_fet6: fet6 {
+			regulator-min-microvolt = <3000000>;
+			regulator-max-microvolt = <5500000>;
 		};
 
 		tps65090_fet7: fet7 {
+			regulator-min-microvolt = <3000000>;
+			regulator-max-microvolt = <5500000>;
 		};
 
 		tps65090_ldo1: ldo1 {
+			regulator-min-microvolt = <6000000>;
+			regulator-max-microvolt = <17000000>;
 		};
 
 		tps65090_ldo2: ldo2 {
+			regulator-min-microvolt = <6000000>;
+			regulator-max-microvolt = <17000000>;
 		};
 	};
 
-- 
2.0.0.rc2

