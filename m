Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbbALSRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:17:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57652 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbbALSGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dominique Leuenberger <dimstar@opensuse.org>, Takashi Iwai <tiwai@suse.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 078/216] hp_accel: Add support for HP ZBook 15
Date: Mon, 12 Jan 2015 18:03:15 +0000
Message-Id: <1421085933-32536-79-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Leuenberger <dimstar@opensuse.org>

commit 6583659e0f92e38079a8dd081e0a1181a0f37747 upstream.

HP ZBook 15 laptop needs a non-standard mapping (x_inverted).

BugLink: http://bugzilla.opensuse.org/show_bug.cgi?id=905329
Signed-off-by: Dominique Leuenberger <dimstar@opensuse.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/platform/x86/hp_accel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index 3dc934438c28..07fbcb0fb646 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -237,6 +237,7 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	AXIS_DMI_MATCH("HPB64xx", "HP ProBook 64", xy_swap),
 	AXIS_DMI_MATCH("HPB64xx", "HP EliteBook 84", xy_swap),
 	AXIS_DMI_MATCH("HPB65xx", "HP ProBook 65", x_inverted),
+	AXIS_DMI_MATCH("HPZBook15", "HP ZBook 15", x_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
-- 
2.1.4

