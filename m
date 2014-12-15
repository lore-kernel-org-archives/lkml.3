Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaLODbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 22:31:42 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:15586 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751260AbaLODba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 22:31:30 -0500
From: Bo Shen <voice.shen@atmel.com>
To: <nicolas.ferre@atmel.com>, Mark Brown <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-sound@vger.kernel.org>, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH v2 3/3] ARM: at91: at91sam9n12ek/dt: use dt ids for wm8904
Date: Mon, 15 Dec 2014 11:31:13 +0800
Message-ID: <1418614273-2303-3-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.1.0.24.g4109c28
In-Reply-To: <1418614273-2303-1-git-send-email-voice.shen@atmel.com>
References: <1418614273-2303-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the device tree ids for wm8904 codec.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

Changes in v2: None

 arch/arm/boot/dts/at91sam9n12ek.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
index 13bb24e..9575c0d 100644
--- a/arch/arm/boot/dts/at91sam9n12ek.dts
+++ b/arch/arm/boot/dts/at91sam9n12ek.dts
@@ -54,7 +54,7 @@
 				status = "okay";
 
 				wm8904: codec@1a {
-					compatible = "wm8904";
+					compatible = "wlf,wm8904";
 					reg = <0x1a>;
 					clocks = <&pck0>;
 					clock-names = "mclk";
-- 
2.1.0.24.g4109c28

