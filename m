Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761AbaCQKD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:03:27 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:56943 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732AbaCQKDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:03:24 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Mark Brown <broonie@kernel.org>, nicolas.ferre@atmel.com
Cc: Bo Shen <voice.shen@atmel.com>, Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] ARM: at91: sama5d3: add the missing property
Date: Mon, 17 Mar 2014 17:45:37 +0800
Message-Id: <1395049541-28128-5-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1395049541-28128-1-git-send-email-voice.shen@atmel.com>
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If without the MICBIAS routing, the record don't work.
Add the missing MICBIAS routing to let record from mic working.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 arch/arm/boot/dts/sama5d3xmb.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
index e1bd5767..0600153 100644
--- a/arch/arm/boot/dts/sama5d3xmb.dtsi
+++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
@@ -166,6 +166,7 @@
 			"Headphone Jack", "HPOUTR",
 			"IN2L", "Line In Jack",
 			"IN2R", "Line In Jack",
+			"MICBIAS", "IN1L",
 			"IN1L", "Mic";
 
 		atmel,ssc-controller = <&ssc0>;
-- 
1.8.5.2

