Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858Ab3BZW4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:56:36 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50951 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758608Ab3BZW4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:56:34 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 07/15] staging: omap-thermal: update OMAP54xx clock sources
Date: Tue, 26 Feb 2013 18:53:30 -0400
Message-ID: <1361919218-9788-8-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
References: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the OMAP54xx data structure to use
the right clock source name for ES2.0.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap5-thermal.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap5-thermal.c b/drivers/staging/omap-thermal/omap5-thermal.c
index 91618fd..c8c3e6e 100644
--- a/drivers/staging/omap-thermal/omap5-thermal.c
+++ b/drivers/staging/omap-thermal/omap5-thermal.c
@@ -323,8 +323,8 @@ const struct omap_bandgap_data omap5430_data = {
 			OMAP_BANDGAP_FEATURE_MODE_CONFIG |
 			OMAP_BANDGAP_FEATURE_COUNTER |
 			OMAP_BANDGAP_FEATURE_CLK_CTRL,
-	.fclock_name = "ts_clk_div_ck",
-	.div_ck_name = "ts_clk_div_ck",
+	.fclock_name = "l3instr_ts_gclk_div",
+	.div_ck_name = "l3instr_ts_gclk_div",
 	.conv_table = omap5430_adc_to_temp,
 	.expose_sensor = omap_thermal_expose_sensor,
 	.remove_sensor = omap_thermal_remove_sensor,
-- 
1.7.7.1.488.ge8e1c

