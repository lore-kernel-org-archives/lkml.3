Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab3JNFlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 01:41:20 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:35711 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3JNFlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 01:41:05 -0400
From: Bo Shen <voice.shen@atmel.com>
To: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 4/5] ARM: at91: enable ssc on at91sam9n12ek board
Date: Mon, 14 Oct 2013 13:38:32 +0800
Message-Id: <1381729113-29714-5-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381729113-29714-1-git-send-email-voice.shen@atmel.com>
References: <1381729113-29714-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable ssc on at91sam9n12ek board

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
 arch/arm/boot/dts/at91sam9n12ek.dts |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
index 1ba8def..391c532 100644
--- a/arch/arm/boot/dts/at91sam9n12ek.dts
+++ b/arch/arm/boot/dts/at91sam9n12ek.dts
@@ -38,6 +38,10 @@
 				status = "okay";
 			};
 
+			ssc0: ssc@f0010000 {
+				status = "okay";
+			};
+
 			i2c0: i2c@f8010000 {
 				status = "okay";
 
-- 
1.7.9.5

