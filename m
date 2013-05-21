Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3EUOIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:08:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39534 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab3EUOIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:08:47 -0400
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <linus.walleij@linaro.org>
CC: <nsekhar@ti.com>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux@arm.linux.org.uk>, <rob@landley.net>, <tony@atomide.com>,
        <prabhakar.csengg@gmail.com>, <peter.ujfalusi@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH 3/3] ARM: davinci: da850: adopt to pinctrl-single driver to configure multiple pins
Date: Tue, 21 May 2013 19:38:02 +0530
Message-ID: <1369145282-14419-5-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369145282-14419-1-git-send-email-prakash.pm@ti.com>
References: <1369145282-14419-1-git-send-email-prakash.pm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

function-mask property is a mask for a pin at each pin configure offset
in a pincontrol register.

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
---
 arch/arm/boot/dts/da850.dtsi |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 4d43046..9bec36c 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -37,7 +37,7 @@
 			#size-cells = <0>;
 			pinctrl-single,bit-per-mux;
 			pinctrl-single,register-width = <32>;
-			pinctrl-single,function-mask = <0xffffffff>;
+			pinctrl-single,function-mask = <0xf>;
 			status = "disabled";
 
 			nand_cs3_pins: pinmux_nand_pins {
-- 
1.7.4.1

