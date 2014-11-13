Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028AbaKMT54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:57:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933146AbaKMT5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:57:55 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Darren Hart <dvhart@infradead.org>
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
        Dominique Leuenberger <dimstar@opensuse.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hp_accel: Add support for HP ZBook 15
Date: Thu, 13 Nov 2014 20:57:37 +0100
Message-Id: <1415908657-26477-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominique Leuenberger <dimstar@opensuse.org>

HP ZBook 15 laptop needs a non-standard mapping (x_inverted).

BugLink: http://bugzilla.opensuse.org/show_bug.cgi?id=905329
Signed-off-by: Dominique Leuenberger <dimstar@opensuse.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/platform/x86/hp_accel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index 13e14ec1d3d7..b268f4e48471 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -237,6 +237,7 @@ static const struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	AXIS_DMI_MATCH("HPB64xx", "HP ProBook 64", xy_swap),
 	AXIS_DMI_MATCH("HPB64xx", "HP EliteBook 84", xy_swap),
 	AXIS_DMI_MATCH("HPB65xx", "HP ProBook 65", x_inverted),
+	AXIS_DMI_MATCH("HPZBook15", "HP ZBook 15", x_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
-- 
2.1.3

