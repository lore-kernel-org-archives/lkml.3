Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab3DXUuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 16:50:44 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:45786 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028Ab3DXUui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 16:50:38 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH v2 03/11] sh-pfc: r8a7790: Add TPU pin groups and functions
Date: Wed, 24 Apr 2013 22:50:08 +0200
Message-Id: <1366836616-21475-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1366836616-21475-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1366836616-21475-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c | 41 ++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7790.c b/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
index 1656915..5be2999 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
@@ -2342,6 +2342,35 @@ static const unsigned int scifb2_data_c_pins[] = {
 static const unsigned int scifb2_data_c_mux[] = {
 	SCIFB2_RXD_C_MARK, SCIFB2_TXD_C_MARK,
 };
+/* - TPU0 ------------------------------------------------------------------- */
+static const unsigned int tpu0_to0_pins[] = {
+	/* TO */
+	RCAR_GP_PIN(0, 20),
+};
+static const unsigned int tpu0_to0_mux[] = {
+	TPU0TO0_MARK,
+};
+static const unsigned int tpu0_to1_pins[] = {
+	/* TO */
+	RCAR_GP_PIN(0, 21),
+};
+static const unsigned int tpu0_to1_mux[] = {
+	TPU0TO1_MARK,
+};
+static const unsigned int tpu0_to2_pins[] = {
+	/* TO */
+	RCAR_GP_PIN(0, 22),
+};
+static const unsigned int tpu0_to2_mux[] = {
+	TPU0TO2_MARK,
+};
+static const unsigned int tpu0_to3_pins[] = {
+	/* TO */
+	RCAR_GP_PIN(0, 23),
+};
+static const unsigned int tpu0_to3_mux[] = {
+	TPU0TO3_MARK,
+};
 
 static const struct sh_pfc_pin_group pinmux_groups[] = {
 	SH_PFC_PIN_GROUP(eth_link),
@@ -2416,6 +2445,10 @@ static const struct sh_pfc_pin_group pinmux_groups[] = {
 	SH_PFC_PIN_GROUP(scifb2_clk_b),
 	SH_PFC_PIN_GROUP(scifb2_ctrl_b),
 	SH_PFC_PIN_GROUP(scifb2_data_c),
+	SH_PFC_PIN_GROUP(tpu0_to0),
+	SH_PFC_PIN_GROUP(tpu0_to1),
+	SH_PFC_PIN_GROUP(tpu0_to2),
+	SH_PFC_PIN_GROUP(tpu0_to3),
 };
 
 static const char * const eth_groups[] = {
@@ -2520,6 +2553,13 @@ static const char * const scifb2_groups[] = {
 	"scifb2_data_c",
 };
 
+static const char * const tpu0_groups[] = {
+	"tpu0_to0",
+	"tpu0_to1",
+	"tpu0_to2",
+	"tpu0_to3",
+};
+
 static const struct sh_pfc_function pinmux_functions[] = {
 	SH_PFC_FUNCTION(eth),
 	SH_PFC_FUNCTION(intc),
@@ -2531,6 +2571,7 @@ static const struct sh_pfc_function pinmux_functions[] = {
 	SH_PFC_FUNCTION(scifb0),
 	SH_PFC_FUNCTION(scifb1),
 	SH_PFC_FUNCTION(scifb2),
+	SH_PFC_FUNCTION(tpu0),
 };
 
 static struct pinmux_cfg_reg pinmux_config_regs[] = {
-- 
1.8.1.5

