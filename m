Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3G2HHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:07:14 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:60879 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab3G2HFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:05:34 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v2 6/6] usb: phy: msm: Fix WARNING: Prefer seq_puts to seq_printf
Date: Mon, 29 Jul 2013 10:04:24 +0300
Message-Id: <1375081464-14206-7-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375081464-14206-1-git-send-email-iivanov@mm-sol.com>
References: <1375081464-14206-1-git-send-email-iivanov@mm-sol.com>
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
index 118bd0a..e370435 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1204,13 +1204,13 @@ static int msm_otg_mode_show(struct seq_file *s, void *unused)
 
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

