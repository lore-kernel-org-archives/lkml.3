Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323AbbA0MRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:17:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34886 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294AbbA0MRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaron Plattner <aplattner@nvidia.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 020/126] ALSA: hda - Add new GPU codec ID 0x10de0072 to snd-hda
Date: Tue, 27 Jan 2015 12:15:25 +0000
Message-Id: <1422361031-19364-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Plattner <aplattner@nvidia.com>

commit 60834b73a9c2bbc2f514122ddc626f3350fb40cd upstream.

Vendor ID 0x10de0072 is used by a yet-to-be-named GPU chip.

Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 210d411c0698..e80c0d60c14b 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -3342,6 +3342,7 @@ static const struct hda_codec_preset snd_hda_preset_hdmi[] = {
 { .id = 0x10de0067, .name = "MCP67 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x10de0070, .name = "GPU 70 HDMI/DP",	.patch = patch_nvhdmi },
 { .id = 0x10de0071, .name = "GPU 71 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0072, .name = "GPU 72 HDMI/DP",	.patch = patch_nvhdmi },
 { .id = 0x10de8001, .name = "MCP73 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x11069f80, .name = "VX900 HDMI/DP",	.patch = patch_via_hdmi },
 { .id = 0x11069f81, .name = "VX900 HDMI/DP",	.patch = patch_via_hdmi },
@@ -3401,6 +3402,7 @@ MODULE_ALIAS("snd-hda-codec-id:10de0060");
 MODULE_ALIAS("snd-hda-codec-id:10de0067");
 MODULE_ALIAS("snd-hda-codec-id:10de0070");
 MODULE_ALIAS("snd-hda-codec-id:10de0071");
+MODULE_ALIAS("snd-hda-codec-id:10de0072");
 MODULE_ALIAS("snd-hda-codec-id:10de8001");
 MODULE_ALIAS("snd-hda-codec-id:11069f80");
 MODULE_ALIAS("snd-hda-codec-id:11069f81");
-- 
2.1.4

