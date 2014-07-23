Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaGWCaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:30:00 -0400
Received: from mout.perfora.net ([74.208.4.196]:65405 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250AbaGWC35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:29:57 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2014 22:29:57 EDT
From: Marcel Ziswiler <marcel@ziswiler.com>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com
Cc: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch, marcel@ziswiler.com
Subject: [PATCH] ARM: tegra: apalis t30: fix device tree compatible node
Date: Wed, 23 Jul 2014 04:23:00 +0200
Message-Id: <aa2cbaac07707c3d64599d3841b9d6f77567a91f.1406081870.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.7.9.5
X-Provags-ID: V02:K0:OzuaTWyE79ORie8Edz88SM/3pFWTmnJMuoihr62Xstv
 2CdhwHqadvEC+xuM+fppPPecrm0LZUnrR/57psqY3PrC+/yYbk
 hWizoOzA56Mmd38J3V6SK+g1a2K04j96B9Z3f+v+3S2cCpLpaQ
 0XbhReL7eTY/LNnZ7N2my+yr2OB8PtbGN6vuVl00eI1vIWAvKz
 kqu1iNHuTMw2r19qErVFAWoQ5MSwJwc7yHMc1EV3ijEQpI8oY9
 f/KpCFSxWhE0P1P8Dhzzh/8jkqNmwTl3TAc5sbqYZ5SbmuWhwN
 eu9LdLY+hR96oxy6IucGWtFvUJTeY5f7SU4vGTAjTY437vP7tb
 Dfq7AMDaOaTOTNdqKKzfLF16EZccjKAC6djEuiSNJCZV/+dFDo
 teCKh3A2/4lnCWqhGg6c8/h7UN1T7PD1/v3XuC1R5ZTImr4S4+
 q0c9ztm2a8TnBsy1jSZaE7xldqQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Working on sound support I noticed the Apalis T30 Evaluation board
device tree missing the more generic Apalis T30 compatible string.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
---
 arch/arm/boot/dts/tegra30-apalis-eval.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra30-apalis-eval.dts b/arch/arm/boot/dts/tegra30-apalis-eval.dts
index 9921433..45d40f0 100644
--- a/arch/arm/boot/dts/tegra30-apalis-eval.dts
+++ b/arch/arm/boot/dts/tegra30-apalis-eval.dts
@@ -5,7 +5,7 @@
 
 / {
 	model = "Toradex Apalis T30 on Apalis Evaluation Board";
-	compatible = "toradex,apalis_t30-eval", "nvidia,tegra30";
+	compatible = "toradex,apalis_t30-eval", "toradex,apalis_t30", "nvidia,tegra30";
 
 	aliases {
 		rtc0 = "/i2c@7000c000/rtc@68";
-- 
1.7.9.5

