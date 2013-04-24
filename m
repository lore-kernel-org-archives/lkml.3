Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3DXAGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 20:06:21 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:39564 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab3DXAGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 20:06:17 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 1/9] sh-pfc: sh73a0: Add TPU pin groups and functions
Date: Wed, 24 Apr 2013 02:06:01 +0200
Message-Id: <1366761969-16759-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1366761969-16759-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1366761969-16759-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/pinctrl/sh-pfc/pfc-sh73a0.c | 213 ++++++++++++++++++++++++++++++++++++
 1 file changed, 213 insertions(+)

diff --git a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c b/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
index ea1fcbe..e4e0c92 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh73a0.c
@@ -2542,6 +2542,157 @@ static const unsigned int sdhi2_ctrl_pins[] = {
 static const unsigned int sdhi2_ctrl_mux[] = {
 	SDHICMD2_MARK, SDHICLK2_MARK,
 };
+/* - TPU0 ------------------------------------------------------------------- */
+static const unsigned int tpu0_to0_pins[] = {
+	/* TO */
+	55,
+};
+static const unsigned int tpu0_to0_mux[] = {
+	TPU0TO0_MARK,
+};
+static const unsigned int tpu0_to1_pins[] = {
+	/* TO */
+	59,
+};
+static const unsigned int tpu0_to1_mux[] = {
+	TPU0TO1_MARK,
+};
+static const unsigned int tpu0_to2_pins[] = {
+	/* TO */
+	140,
+};
+static const unsigned int tpu0_to2_mux[] = {
+	TPU0TO2_MARK,
+};
+static const unsigned int tpu0_to3_pins[] = {
+	/* TO */
+	141,
+};
+static const unsigned int tpu0_to3_mux[] = {
+	TPU0TO3_MARK,
+};
+/* - TPU1 ------------------------------------------------------------------- */
+static const unsigned int tpu1_to0_pins[] = {
+	/* TO */
+	246,
+};
+static const unsigned int tpu1_to0_mux[] = {
+	TPU1TO0_MARK,
+};
+static const unsigned int tpu1_to1_0_pins[] = {
+	/* TO */
+	28,
+};
+static const unsigned int tpu1_to1_0_mux[] = {
+	PORT28_TPU1TO1_MARK,
+};
+static const unsigned int tpu1_to1_1_pins[] = {
+	/* TO */
+	29,
+};
+static const unsigned int tpu1_to1_1_mux[] = {
+	PORT29_TPU1TO1_MARK,
+};
+static const unsigned int tpu1_to2_pins[] = {
+	/* TO */
+	153,
+};
+static const unsigned int tpu1_to2_mux[] = {
+	TPU1TO2_MARK,
+};
+static const unsigned int tpu1_to3_pins[] = {
+	/* TO */
+	145,
+};
+static const unsigned int tpu1_to3_mux[] = {
+	TPU1TO3_MARK,
+};
+/* - TPU2 ------------------------------------------------------------------- */
+static const unsigned int tpu2_to0_pins[] = {
+	/* TO */
+	248,
+};
+static const unsigned int tpu2_to0_mux[] = {
+	TPU2TO0_MARK,
+};
+static const unsigned int tpu2_to1_pins[] = {
+	/* TO */
+	197,
+};
+static const unsigned int tpu2_to1_mux[] = {
+	TPU2TO1_MARK,
+};
+static const unsigned int tpu2_to2_pins[] = {
+	/* TO */
+	50,
+};
+static const unsigned int tpu2_to2_mux[] = {
+	TPU2TO2_MARK,
+};
+static const unsigned int tpu2_to3_pins[] = {
+	/* TO */
+	51,
+};
+static const unsigned int tpu2_to3_mux[] = {
+	TPU2TO3_MARK,
+};
+/* - TPU3 ------------------------------------------------------------------- */
+static const unsigned int tpu3_to0_pins[] = {
+	/* TO */
+	163,
+};
+static const unsigned int tpu3_to0_mux[] = {
+	TPU3TO0_MARK,
+};
+static const unsigned int tpu3_to1_pins[] = {
+	/* TO */
+	247,
+};
+static const unsigned int tpu3_to1_mux[] = {
+	TPU3TO1_MARK,
+};
+static const unsigned int tpu3_to2_pins[] = {
+	/* TO */
+	54,
+};
+static const unsigned int tpu3_to2_mux[] = {
+	TPU3TO2_MARK,
+};
+static const unsigned int tpu3_to3_pins[] = {
+	/* TO */
+	53,
+};
+static const unsigned int tpu3_to3_mux[] = {
+	TPU3TO3_MARK,
+};
+/* - TPU4 ------------------------------------------------------------------- */
+static const unsigned int tpu4_to0_pins[] = {
+	/* TO */
+	241,
+};
+static const unsigned int tpu4_to0_mux[] = {
+	TPU4TO0_MARK,
+};
+static const unsigned int tpu4_to1_pins[] = {
+	/* TO */
+	199,
+};
+static const unsigned int tpu4_to1_mux[] = {
+	TPU4TO1_MARK,
+};
+static const unsigned int tpu4_to2_pins[] = {
+	/* TO */
+	58,
+};
+static const unsigned int tpu4_to2_mux[] = {
+	TPU4TO2_MARK,
+};
+static const unsigned int tpu4_to3_pins[] = {
+	/* TO */
+};
+static const unsigned int tpu4_to3_mux[] = {
+	TPU4TO3_MARK,
+};
 /* - USB -------------------------------------------------------------------- */
 static const unsigned int usb_vbus_pins[] = {
 	/* VBUS */
@@ -2693,6 +2844,27 @@ static const struct sh_pfc_pin_group pinmux_groups[] = {
 	SH_PFC_PIN_GROUP(sdhi2_data1),
 	SH_PFC_PIN_GROUP(sdhi2_data4),
 	SH_PFC_PIN_GROUP(sdhi2_ctrl),
+	SH_PFC_PIN_GROUP(tpu0_to0),
+	SH_PFC_PIN_GROUP(tpu0_to1),
+	SH_PFC_PIN_GROUP(tpu0_to2),
+	SH_PFC_PIN_GROUP(tpu0_to3),
+	SH_PFC_PIN_GROUP(tpu1_to0),
+	SH_PFC_PIN_GROUP(tpu1_to1_0),
+	SH_PFC_PIN_GROUP(tpu1_to1_1),
+	SH_PFC_PIN_GROUP(tpu1_to2),
+	SH_PFC_PIN_GROUP(tpu1_to3),
+	SH_PFC_PIN_GROUP(tpu2_to0),
+	SH_PFC_PIN_GROUP(tpu2_to1),
+	SH_PFC_PIN_GROUP(tpu2_to2),
+	SH_PFC_PIN_GROUP(tpu2_to3),
+	SH_PFC_PIN_GROUP(tpu3_to0),
+	SH_PFC_PIN_GROUP(tpu3_to1),
+	SH_PFC_PIN_GROUP(tpu3_to2),
+	SH_PFC_PIN_GROUP(tpu3_to3),
+	SH_PFC_PIN_GROUP(tpu4_to0),
+	SH_PFC_PIN_GROUP(tpu4_to1),
+	SH_PFC_PIN_GROUP(tpu4_to2),
+	SH_PFC_PIN_GROUP(tpu4_to3),
 	SH_PFC_PIN_GROUP(usb_vbus),
 };
 
@@ -2912,6 +3084,42 @@ static const char * const usb_groups[] = {
 	"usb_vbus",
 };
 
+static const char * const tpu0_groups[] = {
+	"tpu0_to0",
+	"tpu0_to1",
+	"tpu0_to2",
+	"tpu0_to3",
+};
+
+static const char * const tpu1_groups[] = {
+	"tpu1_to0",
+	"tpu1_to1_0",
+	"tpu1_to1_1",
+	"tpu1_to2",
+	"tpu1_to3",
+};
+
+static const char * const tpu2_groups[] = {
+	"tpu2_to0",
+	"tpu2_to1",
+	"tpu2_to2",
+	"tpu2_to3",
+};
+
+static const char * const tpu3_groups[] = {
+	"tpu3_to0",
+	"tpu3_to1",
+	"tpu3_to2",
+	"tpu3_to3",
+};
+
+static const char * const tpu4_groups[] = {
+	"tpu4_to0",
+	"tpu4_to1",
+	"tpu4_to2",
+	"tpu4_to3",
+};
+
 static const struct sh_pfc_function pinmux_functions[] = {
 	SH_PFC_FUNCTION(bsc),
 	SH_PFC_FUNCTION(fsia),
@@ -2937,6 +3145,11 @@ static const struct sh_pfc_function pinmux_functions[] = {
 	SH_PFC_FUNCTION(sdhi0),
 	SH_PFC_FUNCTION(sdhi1),
 	SH_PFC_FUNCTION(sdhi2),
+	SH_PFC_FUNCTION(tpu0),
+	SH_PFC_FUNCTION(tpu1),
+	SH_PFC_FUNCTION(tpu2),
+	SH_PFC_FUNCTION(tpu3),
+	SH_PFC_FUNCTION(tpu4),
 	SH_PFC_FUNCTION(usb),
 };
 
-- 
1.8.1.5

