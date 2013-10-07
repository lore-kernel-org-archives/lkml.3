Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab3JGTP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:15:29 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1535 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217Ab3JGTPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:15:19 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Christian Daudt" <bcm@fixthebug.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Wolfram Sang" <wsa@the-dreams.de>,
        "Grant Likely" <grant.likely@linaro.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/4] ARM: dts: bcm28155-ap: Enable all the i2c busses
Date: Mon, 7 Oct 2013 12:15:01 -0700
Message-ID: <1381173301-23830-5-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1381173301-23830-1-git-send-email-tim.kryger@linaro.org>
References: <1381173301-23830-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E4DD7B12L892392557-01-01
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


