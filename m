Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaJPRMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:12:20 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35258 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaJPRMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:12:17 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [PATCH RFC v2 7/8] pinctrl: zynq: Use generic map_all function
Date: Thu, 16 Oct 2014 10:11:34 -0700
Message-Id: <1413479495-14206-8-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.2.1.g5e69ed6
In-Reply-To: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic pinconf_generic_dt_node_to_map_all() function
to parse config and mux settings from DT.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/pinctrl/pinctrl-zynq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-zynq.c b/drivers/pinctrl/pinctrl-zynq.c
index 0136bddbb4be..743a6f563c1e 100644
--- a/drivers/pinctrl/pinctrl-zynq.c
+++ b/drivers/pinctrl/pinctrl-zynq.c
@@ -790,7 +790,7 @@ static const struct pinctrl_ops zynq_pctrl_ops = {
 	.get_groups_count = zynq_pctrl_get_groups_count,
 	.get_group_name = zynq_pctrl_get_group_name,
 	.get_group_pins = zynq_pctrl_get_group_pins,
-	.dt_node_to_map = pinconf_generic_dt_node_to_map_group,
+	.dt_node_to_map = pinconf_generic_dt_node_to_map_all,
 	.dt_free_map = pinctrl_utils_dt_free_map
 };
 
-- 
2.1.2.1.g5e69ed6

