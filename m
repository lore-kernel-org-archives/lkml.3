Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaGHHVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:21:53 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13494 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaGHHVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:21:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 08 Jul 2014 00:11:07 -0700
From: Aaron Plattner <aplattner@nvidia.com>
To: Anssi Hannula <anssi.hannula@iki.fi>, Takashi Iwai <tiwai@suse.de>
CC: Aaron Plattner <aplattner@nvidia.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ALSA: hda - Add new GPU codec ID 0x10de0070 to snd-hda
Date: Tue, 8 Jul 2014 00:21:38 -0700
Message-ID: <1404804098-11570-1-git-send-email-aplattner@nvidia.com>
X-Mailer: git-send-email 2.0.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vendor ID 0x10de0070 is used by a yet-to-be-named GPU chip.

Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
---
Another day, another Azalia codec ID.  I verified that the patch_nvhdmi code is
still needed for this chip.

 sound/pci/hda/patch_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 3e4417b0ddbe..1df5cf629a24 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -3337,6 +3337,7 @@ static const struct hda_codec_preset snd_hda_preset_hdmi[] = {
 { .id = 0x10de0051, .name = "GPU 51 HDMI/DP",	.patch = patch_nvhdmi },
 { .id = 0x10de0060, .name = "GPU 60 HDMI/DP",	.patch = patch_nvhdmi },
 { .id = 0x10de0067, .name = "MCP67 HDMI",	.patch = patch_nvhdmi_2ch },
+{ .id = 0x10de0070, .name = "GPU 70 HDMI/DP",	.patch = patch_nvhdmi },
 { .id = 0x10de0071, .name = "GPU 71 HDMI/DP",	.patch = patch_nvhdmi },
 { .id = 0x10de8001, .name = "MCP73 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x11069f80, .name = "VX900 HDMI/DP",	.patch = patch_via_hdmi },
@@ -3394,6 +3395,7 @@ MODULE_ALIAS("snd-hda-codec-id:10de0044");
 MODULE_ALIAS("snd-hda-codec-id:10de0051");
 MODULE_ALIAS("snd-hda-codec-id:10de0060");
 MODULE_ALIAS("snd-hda-codec-id:10de0067");
+MODULE_ALIAS("snd-hda-codec-id:10de0070");
 MODULE_ALIAS("snd-hda-codec-id:10de0071");
 MODULE_ALIAS("snd-hda-codec-id:10de8001");
 MODULE_ALIAS("snd-hda-codec-id:11069f80");
-- 
2.0.1

