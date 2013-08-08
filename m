Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966184Ab3HHTIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 15:08:11 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1944 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758155Ab3HHTIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 15:08:07 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Christian Daudt" <csd@broadcom.com>
To: "Christian Daudt" <csd@broadcom.com>
cc: "Lee Jones" <lee.jones@linaro.org>, "Alex Elder" <elder@linaro.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ian.campbell@citrix.com>,
        "Russell King" <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: dts: add sdio blocks to bcm28155-ap board
Date: Thu, 8 Aug 2013 12:07:54 -0700
Message-ID: <1375988874-11303-2-git-send-email-csd@broadcom.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375988874-11303-1-git-send-email-csd@broadcom.com>
References: <1375988874-11303-1-git-send-email-csd@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7E1D34951R078611367-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable sdio for bcm28155 AP board

Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Christian Daudt <csd@broadcom.com>

diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
index 0d66db6..4b0a3ec 100644
--- a/arch/arm/boot/dts/bcm28155-ap.dts
+++ b/arch/arm/boot/dts/bcm28155-ap.dts
@@ -26,4 +26,20 @@
 	uart@3e000000 {
 		status = "okay";
 	};
+
+	sdio1: sdio@3f180000 {
+		max-frequency = <48000000>;
+		status = "okay";
+	};
+
+	sdio2: sdio@3f190000 {
+		non-removable;
+		max-frequency = <48000000>;
+		status = "okay";
+	};
+
+	sdio4: sdio@3f1b0000 {
+		max-frequency = <48000000>;
+		status = "okay";
+	};
 };
-- 
1.7.10.4


