Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbaGORMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:12:18 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50812 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbaGORCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:18 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Olof Johansson <olof@lixom.net>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 76/94] ARM: at91: at91sam9x5: add clocks for usb device
Date: Tue, 15 Jul 2014 20:01:31 +0300
Message-Id: <1405443709-15288-76-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bo Shen <voice.shen@atmel.com>

Add clocks for usb device, or else switch to CCF, the gadget
won't work.

Reported-by: Jiri Prchal <jiri.prchal@aksignal.cz>
Signed-off-by: Bo Shen <voice.shen@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Tested-by: Jiri Prchal <jiri.prchal@aksignal.cz>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/boot/dts/at91sam9x5.dtsi |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index d6133f4..2ebc421 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -1045,6 +1045,8 @@
 				reg = <0x00500000 0x80000
 				       0xf803c000 0x400>;
 				interrupts = <23 IRQ_TYPE_LEVEL_HIGH 0>;
+				clocks = <&usb>, <&udphs_clk>;
+				clock-names = "hclk", "pclk";
 				status = "disabled";
 
 				ep0 {
-- 
1.7.10.4

