Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746AbaCQKDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:03:21 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:30702 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732AbaCQKDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:03:19 -0400
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
Subject: [PATCH 5/8] ARM: at91: sama5d3: clock for ssc from rk pin
Date: Mon, 17 Mar 2014 17:45:38 +0800
Message-Id: <1395049541-28128-6-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1395049541-28128-1-git-send-email-voice.shen@atmel.com>
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to hardware design the clock for SSC device is from rk pin.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 arch/arm/boot/dts/sama5d3xmb.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
index 0600153..306eef0 100644
--- a/arch/arm/boot/dts/sama5d3xmb.dtsi
+++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
@@ -32,6 +32,10 @@
 				};
 			};
 
+			ssc0: ssc@f0008000 {
+				atmel,clk-from-rk-pin;
+			};
+
 			/*
 			 * i2c0 conflicts with ISI:
 			 * disable it to allow the use of ISI
-- 
1.8.5.2

