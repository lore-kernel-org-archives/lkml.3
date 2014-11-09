Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaKIIev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 03:34:51 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:50390 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaKIIes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 03:34:48 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 3/3] ARM: dts: meson: add IR receiver node
Date: Sun,  9 Nov 2014 09:32:08 +0100
Message-Id: <1415521928-25251-4-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415521928-25251-1-git-send-email-b.galvani@gmail.com>
References: <1415521928-25251-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a node for the IR remote control receiver to the Amlogic
Meson DTS.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 arch/arm/boot/dts/meson.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/meson.dtsi b/arch/arm/boot/dts/meson.dtsi
index e6539ea..6a37f15 100644
--- a/arch/arm/boot/dts/meson.dtsi
+++ b/arch/arm/boot/dts/meson.dtsi
@@ -106,5 +106,12 @@
 			clocks = <&clk81>;
 			status = "disabled";
 		};
+
+		ir_receiver: ir-receiver@c8100480 {
+			compatible= "amlogic,meson6-ir";
+			reg = <0xc8100480 0x20>;
+			interrupts = <0 15 1>;
+			status = "disabled";
+		};
 	};
 }; /* end of / */
-- 
1.9.1

