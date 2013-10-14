Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab3JNP3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:29:35 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:49796 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756962Ab3JNP0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:26:05 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, jackp@codeaurora.org, mgautam@codeaurora.org,
        dsegal@codeaurora.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v3 06/13] usb: phy: msm: Fix WARNING: Prefer seq_puts to seq_printf
Date: Mon, 14 Oct 2013 18:24:33 +0300
Message-Id: <1381764280-28420-7-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
References: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

This fixes checkpatch.pl warnings.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 28cab03..46800c0 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1231,13 +1231,13 @@ static int msm_otg_mode_show(struct seq_file *s, void *unused)
 
 	switch (otg->phy->state) {
 	case OTG_STATE_A_HOST:
-		seq_printf(s, "host\n");
+		seq_puts(s, "host\n");
 		break;
 	case OTG_STATE_B_PERIPHERAL:
-		seq_printf(s, "peripheral\n");
+		seq_puts(s, "peripheral\n");
 		break;
 	default:
-		seq_printf(s, "none\n");
+		seq_puts(s, "none\n");
 		break;
 	}
 
-- 
1.7.9.5

