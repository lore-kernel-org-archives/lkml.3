Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab3G3JxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:53:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53072 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab3G3Jct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaron Plattner <aplattner@nvidia.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 035/106] ALSA: hda - Add new GPU codec ID to snd-hda
Date: Tue, 30 Jul 2013 10:30:54 +0100
Message-Id: <1375176725-5825-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Plattner <aplattner@nvidia.com>

commit d52392b1a80458c0510810789c7db4a39b88022a upstream.

Vendor ID 0x10de0060 is used by a yet-to-be-named GPU chip.

Reviewed-by: Andy Ritger <aritger@nvidia.com>
Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 5763427..375e0ff 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1898,6 +1898,7 @@ static const struct hda_codec_preset snd_hda_preset_hdmi[] = {
 { .id = 0x10de0043, .name = "GPU 43 HDMI/DP",	.patch = patch_generic_hdmi },
 { .id = 0x10de0044, .name = "GPU 44 HDMI/DP",	.patch = patch_generic_hdmi },
 { .id = 0x10de0051, .name = "GPU 51 HDMI/DP",	.patch = patch_generic_hdmi },
+{ .id = 0x10de0060, .name = "GPU 60 HDMI/DP",	.patch = patch_generic_hdmi },
 { .id = 0x10de0067, .name = "MCP67 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x10de8001, .name = "MCP73 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x80860054, .name = "IbexPeak HDMI",	.patch = patch_generic_hdmi },
@@ -1945,6 +1946,7 @@ MODULE_ALIAS("snd-hda-codec-id:10de0042");
 MODULE_ALIAS("snd-hda-codec-id:10de0043");
 MODULE_ALIAS("snd-hda-codec-id:10de0044");
 MODULE_ALIAS("snd-hda-codec-id:10de0051");
+MODULE_ALIAS("snd-hda-codec-id:10de0060");
 MODULE_ALIAS("snd-hda-codec-id:10de0067");
 MODULE_ALIAS("snd-hda-codec-id:10de8001");
 MODULE_ALIAS("snd-hda-codec-id:17e80047");
-- 
1.8.3.2

