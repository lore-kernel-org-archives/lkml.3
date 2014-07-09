Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbaGIM1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:27:52 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:55348 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbaGIMX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:23:56 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 07/13] ARM: shmobile: r8a73a4 dtsi: Add SoC-specific irqc compatible property
Date: Wed,  9 Jul 2014 14:23:37 +0200
Message-Id: <1404908623-909-8-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt controller used the generic compatible property only.
Add the SoC-specific one, to make it future proof.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/boot/dts/r8a73a4.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/r8a73a4.dtsi b/arch/arm/boot/dts/r8a73a4.dtsi
index 82c5ac825386..f3bd3d4603d7 100644
--- a/arch/arm/boot/dts/r8a73a4.dtsi
+++ b/arch/arm/boot/dts/r8a73a4.dtsi
@@ -51,7 +51,7 @@
 	};
 
 	irqc0: interrupt-controller@e61c0000 {
-		compatible = "renesas,irqc";
+		compatible = "renesas,irqc-r8a73a4", "renesas,irqc";
 		#interrupt-cells = <2>;
 		interrupt-controller;
 		reg = <0 0xe61c0000 0 0x200>;
@@ -90,7 +90,7 @@
 	};
 
 	irqc1: interrupt-controller@e61c0200 {
-		compatible = "renesas,irqc";
+		compatible = "renesas,irqc-r8a73a4", "renesas,irqc";
 		#interrupt-cells = <2>;
 		interrupt-controller;
 		reg = <0 0xe61c0200 0 0x200>;
-- 
1.9.1

