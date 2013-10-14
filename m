Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab3JNFlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 01:41:14 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:52595 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3JNFlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 01:41:02 -0400
From: Bo Shen <voice.shen@atmel.com>
To: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 3/5] ARM: at91: enable wm8904 on at91sam9n12ek board
Date: Mon, 14 Oct 2013 13:38:31 +0800
Message-Id: <1381729113-29714-4-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381729113-29714-1-git-send-email-voice.shen@atmel.com>
References: <1381729113-29714-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable wm8904 codec on at91sam9n12ek board, which is connect
to i2c0 bus with 0x1a as address.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
 arch/arm/boot/dts/at91sam9n12ek.dts |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
index 27a9352..1ba8def 100644
--- a/arch/arm/boot/dts/at91sam9n12ek.dts
+++ b/arch/arm/boot/dts/at91sam9n12ek.dts
@@ -41,6 +41,11 @@
 			i2c0: i2c@f8010000 {
 				status = "okay";
 
+				wm8904: codec@1a {
+					compatible = "wm8904";
+					reg = <0x1a>;
+				};
+
 				qt1070: keyboard@1b {
 					compatible = "qt1070";
 					reg = <0x1b>;
-- 
1.7.9.5

