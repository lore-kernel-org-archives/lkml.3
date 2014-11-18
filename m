Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbaKRUZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:25:39 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:57257 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbaKRUZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:25:35 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        Sean Young <sean@mess.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v3 3/3] ARM: dts: meson: add IR receiver node
Date: Tue, 18 Nov 2014 21:22:35 +0100
Message-Id: <1416342155-26820-4-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416342155-26820-1-git-send-email-b.galvani@gmail.com>
References: <1416342155-26820-1-git-send-email-b.galvani@gmail.com>
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

