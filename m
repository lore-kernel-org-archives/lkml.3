Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbbANH2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:28:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbbANH2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:28:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaron Plattner <aplattner@nvidia.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.18 082/150] ALSA: hda - Add new GPU codec ID 0x10de0072 to snd-hda
Date: Tue, 13 Jan 2015 23:22:33 -0800
Message-Id: <20150114072059.563259316@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Plattner <aplattner@nvidia.com>

commit 60834b73a9c2bbc2f514122ddc626f3350fb40cd upstream.

Vendor ID 0x10de0072 is used by a yet-to-be-named GPU chip.

Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -3351,6 +3351,7 @@ static const struct hda_codec_preset snd
 { .id = 0x10de0067, .name = "MCP67 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x10de0070, .name = "GPU 70 HDMI/DP",	.patch = patch_nvhdmi },
 { .id = 0x10de0071, .name = "GPU 71 HDMI/DP",	.patch = patch_nvhdmi },
+{ .id = 0x10de0072, .name = "GPU 72 HDMI/DP",	.patch = patch_nvhdmi },
 { .id = 0x10de8001, .name = "MCP73 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x11069f80, .name = "VX900 HDMI/DP",	.patch = patch_via_hdmi },
 { .id = 0x11069f81, .name = "VX900 HDMI/DP",	.patch = patch_via_hdmi },
@@ -3410,6 +3411,7 @@ MODULE_ALIAS("snd-hda-codec-id:10de0060"
 MODULE_ALIAS("snd-hda-codec-id:10de0067");
 MODULE_ALIAS("snd-hda-codec-id:10de0070");
 MODULE_ALIAS("snd-hda-codec-id:10de0071");
+MODULE_ALIAS("snd-hda-codec-id:10de0072");
 MODULE_ALIAS("snd-hda-codec-id:10de8001");
 MODULE_ALIAS("snd-hda-codec-id:11069f80");
 MODULE_ALIAS("snd-hda-codec-id:11069f81");


