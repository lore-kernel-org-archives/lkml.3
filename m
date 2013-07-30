Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3G3PVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:21:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55413 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab3G3PUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:20:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaron Plattner <aplattner@nvidia.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 32/75] ALSA: hda - Add new GPU codec ID to snd-hda
Date: Tue, 30 Jul 2013 08:17:01 -0700
Message-Id: <1375197464-27962-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Plattner <aplattner@nvidia.com>

commit d52392b1a80458c0510810789c7db4a39b88022a upstream.

Vendor ID 0x10de0060 is used by a yet-to-be-named GPU chip.

Reviewed-by: Andy Ritger <aritger@nvidia.com>
Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index f186897..ad23390 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2339,6 +2339,7 @@ static const struct hda_codec_preset snd_hda_preset_hdmi[] = {
 { .id = 0x10de0043, .name = "GPU 43 HDMI/DP",	.patch = patch_generic_hdmi },
 { .id = 0x10de0044, .name = "GPU 44 HDMI/DP",	.patch = patch_generic_hdmi },
 { .id = 0x10de0051, .name = "GPU 51 HDMI/DP",	.patch = patch_generic_hdmi },
+{ .id = 0x10de0060, .name = "GPU 60 HDMI/DP",	.patch = patch_generic_hdmi },
 { .id = 0x10de0067, .name = "MCP67 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x10de8001, .name = "MCP73 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x11069f80, .name = "VX900 HDMI/DP",	.patch = patch_via_hdmi },
@@ -2391,6 +2392,7 @@ MODULE_ALIAS("snd-hda-codec-id:10de0042");
 MODULE_ALIAS("snd-hda-codec-id:10de0043");
 MODULE_ALIAS("snd-hda-codec-id:10de0044");
 MODULE_ALIAS("snd-hda-codec-id:10de0051");
+MODULE_ALIAS("snd-hda-codec-id:10de0060");
 MODULE_ALIAS("snd-hda-codec-id:10de0067");
 MODULE_ALIAS("snd-hda-codec-id:10de8001");
 MODULE_ALIAS("snd-hda-codec-id:11069f80");
-- 
1.8.1.2

