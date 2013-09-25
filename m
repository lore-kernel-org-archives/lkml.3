Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3IYLLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 07:11:47 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:59115 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab3IYLLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 07:11:46 -0400
From: Luis Ortega Perez de Villar <luiorpe1@upv.es>
To: paulz@synopsys.com
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Luis Ortega Perez de Villar <luiorpe1@upv.es>
Subject: [PATCH] Staging: dwc2: core: coding style - indentation should use tabs
Date: Wed, 25 Sep 2013 13:10:50 +0200
Message-Id: <1380107450-7241-1-git-send-email-luiorpe1@upv.es>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue where lines are indented with spaces
instead of tabs.

Signed-off-by: Luis Ortega Perez de Villar <luiorpe1@upv.es>
---
 drivers/staging/dwc2/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dwc2/core.c b/drivers/staging/dwc2/core.c
index 06dae67..f8dfca1 100644
--- a/drivers/staging/dwc2/core.c
+++ b/drivers/staging/dwc2/core.c
@@ -2205,7 +2205,7 @@ int dwc2_set_param_phy_type(struct dwc2_hsotg *hsotg, int val)
 {
 #ifndef NO_FS_PHY_HW_CHECKS
 	int valid = 0;
-        u32 hs_phy_type, fs_phy_type;
+	u32 hs_phy_type, fs_phy_type;
 #endif
 	int retval = 0;
 
@@ -2553,7 +2553,7 @@ int dwc2_set_param_ahbcfg(struct dwc2_hsotg *hsotg, int val)
 		hsotg->core_params->ahbcfg = val;
 	else
 		hsotg->core_params->ahbcfg = GAHBCFG_HBSTLEN_INCR4 <<
-                                             GAHBCFG_HBSTLEN_SHIFT;
+						GAHBCFG_HBSTLEN_SHIFT;
 	return 0;
 }
 
-- 
1.7.9.5

