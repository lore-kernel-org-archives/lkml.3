Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaBJKtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:49:49 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:37485 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaBJKrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:47:43 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 2/7] ARM: shmobile: lager legacy: Add QSPI pinmux
Date: Mon, 10 Feb 2014 11:47:28 +0100
Message-Id: <1392029254-15400-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392029254-15400-1-git-send-email-geert@linux-m68k.org>
References: <1392029254-15400-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 arch/arm/mach-shmobile/board-lager.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mach-shmobile/board-lager.c b/arch/arm/mach-shmobile/board-lager.c
index 317574864e7b..9e52efa2a457 100644
--- a/arch/arm/mach-shmobile/board-lager.c
+++ b/arch/arm/mach-shmobile/board-lager.c
@@ -606,6 +606,11 @@ static const struct pinctrl_map lager_pinctrl_map[] = {
 	/* I2C2 */
 	PIN_MAP_MUX_GROUP_DEFAULT("i2c-rcar.2", "pfc-r8a7790",
 				  "i2c2", "i2c2"),
+	/* QSPI */
+	PIN_MAP_MUX_GROUP_DEFAULT("qspi.0", "pfc-r8a7790",
+				  "qspi_ctrl", "qspi"),
+	PIN_MAP_MUX_GROUP_DEFAULT("qspi.0", "pfc-r8a7790",
+				  "qspi_data4", "qspi"),
 	/* SCIF0 (CN19: DEBUG SERIAL0) */
 	PIN_MAP_MUX_GROUP_DEFAULT("sh-sci.6", "pfc-r8a7790",
 				  "scif0_data", "scif0"),
-- 
1.7.9.5

