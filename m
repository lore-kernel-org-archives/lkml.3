Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354Ab3DXUxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 16:53:35 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:45784 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005Ab3DXUui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 16:50:38 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v2 02/11] sh-pfc: r8a7740: Add TPU pin groups and functions
Date: Wed, 24 Apr 2013 22:50:07 +0200
Message-Id: <1366836616-21475-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1366836616-21475-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1366836616-21475-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c | 50 ++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7740.c b/drivers/pinctrl/sh-pfc/pfc-r8a7740.c
index e5ef587..f6ea47c 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7740.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7740.c
@@ -2745,6 +2745,42 @@ static const unsigned int sdhi2_wp_1_pins[] = {
 static const unsigned int sdhi2_wp_1_mux[] = {
 	SDHI2_WP_PORT25_MARK,
 };
+/* - TPU0 ------------------------------------------------------------------- */
+static const unsigned int tpu0_to0_pins[] = {
+	/* TO */
+	23,
+};
+static const unsigned int tpu0_to0_mux[] = {
+	TPU0TO0_MARK,
+};
+static const unsigned int tpu0_to1_pins[] = {
+	/* TO */
+	21,
+};
+static const unsigned int tpu0_to1_mux[] = {
+	TPU0TO1_MARK,
+};
+static const unsigned int tpu0_to2_0_pins[] = {
+	/* TO */
+	66,
+};
+static const unsigned int tpu0_to2_0_mux[] = {
+	TPU0TO2_PORT66_MARK,
+};
+static const unsigned int tpu0_to2_1_pins[] = {
+	/* TO */
+	202,
+};
+static const unsigned int tpu0_to2_1_mux[] = {
+	TPU0TO2_PORT202_MARK,
+};
+static const unsigned int tpu0_to3_pins[] = {
+	/* TO */
+	180,
+};
+static const unsigned int tpu0_to3_mux[] = {
+	TPU0TO3_MARK,
+};
 
 static const struct sh_pfc_pin_group pinmux_groups[] = {
 	SH_PFC_PIN_GROUP(bsc_data8),
@@ -2926,6 +2962,11 @@ static const struct sh_pfc_pin_group pinmux_groups[] = {
 	SH_PFC_PIN_GROUP(sdhi2_wp_0),
 	SH_PFC_PIN_GROUP(sdhi2_cd_1),
 	SH_PFC_PIN_GROUP(sdhi2_wp_1),
+	SH_PFC_PIN_GROUP(tpu0_to0),
+	SH_PFC_PIN_GROUP(tpu0_to1),
+	SH_PFC_PIN_GROUP(tpu0_to2_0),
+	SH_PFC_PIN_GROUP(tpu0_to2_1),
+	SH_PFC_PIN_GROUP(tpu0_to3),
 };
 
 static const char * const bsc_groups[] = {
@@ -3176,6 +3217,14 @@ static const char * const sdhi2_groups[] = {
 	"sdhi2_wp_1",
 };
 
+static const char * const tpu0_groups[] = {
+	"tpu0_to0",
+	"tpu0_to1",
+	"tpu0_to2_0",
+	"tpu0_to2_1",
+	"tpu0_to3",
+};
+
 static const struct sh_pfc_function pinmux_functions[] = {
 	SH_PFC_FUNCTION(bsc),
 	SH_PFC_FUNCTION(ceu0),
@@ -3200,6 +3249,7 @@ static const struct sh_pfc_function pinmux_functions[] = {
 	SH_PFC_FUNCTION(sdhi0),
 	SH_PFC_FUNCTION(sdhi1),
 	SH_PFC_FUNCTION(sdhi2),
+	SH_PFC_FUNCTION(tpu0),
 };
 
 #undef PORTCR
-- 
1.8.1.5

