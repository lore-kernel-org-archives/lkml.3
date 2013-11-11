Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3KKNoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:44:02 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:54331 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab3KKNnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:43:43 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: alexander.shishkin@linux.intel.com
Cc: gregkh@linuxfoundation.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH 3/4] usb: chipidea: msm: Initialize offset of the capability registers
Date: Mon, 11 Nov 2013 15:35:36 +0200
Message-Id: <1384176937-1658-4-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
References: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/chipidea/ci_hdrc_msm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
index 747d6c1..e9624f3 100644
--- a/drivers/usb/chipidea/ci_hdrc_msm.c
+++ b/drivers/usb/chipidea/ci_hdrc_msm.c
@@ -47,6 +47,7 @@ static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
 
 static struct ci_hdrc_platform_data ci_hdrc_msm_platdata = {
 	.name			= "ci_hdrc_msm",
+	.capoffset		= DEF_CAPOFFSET,
 	.flags			= CI_HDRC_REGS_SHARED |
 				  CI_HDRC_REQUIRE_TRANSCEIVER |
 				  CI_HDRC_DISABLE_STREAMING,
-- 
1.7.9.5

