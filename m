Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbaBJKry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:47:54 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:48309 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaBJKrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:47:47 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 7/7] ARM: shmobile: lager dts: Enable Quad SPI transfers for the SPI FLASH
Date: Mon, 10 Feb 2014 11:47:33 +0100
Message-Id: <1392029254-15400-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392029254-15400-1-git-send-email-geert@linux-m68k.org>
References: <1392029254-15400-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
This depends on spi-rspi updates

 arch/arm/boot/dts/r8a7790-lager.dts |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index adff2dc4012d..0b47ade38340 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -113,6 +113,8 @@
 		compatible = "spansion,s25fl512s";
 		reg = <0>;
 		spi-max-frequency = <30000000>;
+		spi-tx-bus-width = <4>;
+		spi-rx-bus-width = <4>;
 		m25p,fast-read;
 
 		partition@0 {
-- 
1.7.9.5

