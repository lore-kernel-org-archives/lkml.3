Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbbA2JsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:48:01 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44819 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932137AbbA2JEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:04:24 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dominique Leuenberger <dimstar@opensuse.org>,
        Takashi Iwai <tiwai@suse.de>, Darren Hart <dvhart@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 081/176] hp_accel: Add support for HP ZBook 15
Date: Wed, 28 Jan 2015 15:28:31 +0100
Message-Id: <666f1afd7184fc0ac3a02bc4a3cd4d1f752d4cb0.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominique Leuenberger <dimstar@opensuse.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6583659e0f92e38079a8dd081e0a1181a0f37747 upstream.

HP ZBook 15 laptop needs a non-standard mapping (x_inverted).

BugLink: http://bugzilla.opensuse.org/show_bug.cgi?id=905329
Signed-off-by: Dominique Leuenberger <dimstar@opensuse.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/platform/x86/hp_accel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index 0ed96df20162..3458eb6fd491 100644
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
2.2.2

