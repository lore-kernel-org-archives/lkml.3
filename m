Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab3KNVD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 16:03:28 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:3728 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361Ab3KNVCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 16:02:50 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Christian Daudt" <bcm@fixthebug.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Wolfram Sang" <wsa@the-dreams.de>,
        "Grant Likely" <grant.likely@linaro.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>,
        "Device Tree List" <devicetree@vger.kernel.org>,
        "Linux Doc List" <linux-doc@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux I2C List" <linux-i2c@vger.kernel.org>,
        "Linux ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linaro Patches List" <patches@linaro.org>
Subject: [PATCH v2 5/5] ARM: dts: bcm28155-ap: Enable all the i2c busses
Date: Thu, 14 Nov 2013 13:02:16 -0800
Message-ID: <1384462936-7906-6-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1384462936-7906-1-git-send-email-tim.kryger@linaro.org>
References: <1384462936-7906-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E9BE5D94RS8219855-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable all available i2c busses.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Christian Daudt <csd@broadcom.com>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/boot/dts/bcm28155-ap.dts | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
index 08e47c2..bab302d 100644
--- a/arch/arm/boot/dts/bcm28155-ap.dts
+++ b/arch/arm/boot/dts/bcm28155-ap.dts
@@ -27,6 +27,26 @@
 		status = "okay";
 	};
 
+	i2c@3e016000 {
+		status="okay";
+		clock-frequency = <400000>;
+	};
+
+	i2c@3e017000 {
+		status="okay";
+		clock-frequency = <400000>;
+	};
+
+	i2c@3e018000 {
+		status="okay";
+		clock-frequency = <400000>;
+	};
+
+	i2c@3500d000 {
+		status="okay";
+		clock-frequency = <400000>;
+	};
+
 	sdio1: sdio@3f180000 {
 		max-frequency = <48000000>;
 		status = "okay";
-- 
1.8.0.1


