Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647Ab3GWWvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:51:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934426Ab3GWW1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Ritger <aritger@nvidia.com>,
        Aaron Plattner <aplattner@nvidia.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 031/103] ALSA: hda - Add new GPU codec ID to snd-hda
Date: Tue, 23 Jul 2013 15:25:42 -0700
Message-Id: <20130723220422.027849923@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Plattner <aplattner@nvidia.com>

commit d52392b1a80458c0510810789c7db4a39b88022a upstream.

Vendor ID 0x10de0060 is used by a yet-to-be-named GPU chip.

Reviewed-by: Andy Ritger <aritger@nvidia.com>
Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -2536,6 +2536,7 @@ static const struct hda_codec_preset snd
 { .id = 0x10de0043, .name = "GPU 43 HDMI/DP",	.patch = patch_generic_hdmi },
 { .id = 0x10de0044, .name = "GPU 44 HDMI/DP",	.patch = patch_generic_hdmi },
 { .id = 0x10de0051, .name = "GPU 51 HDMI/DP",	.patch = patch_generic_hdmi },
+{ .id = 0x10de0060, .name = "GPU 60 HDMI/DP",	.patch = patch_generic_hdmi },
 { .id = 0x10de0067, .name = "MCP67 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x10de8001, .name = "MCP73 HDMI",	.patch = patch_nvhdmi_2ch },
 { .id = 0x11069f80, .name = "VX900 HDMI/DP",	.patch = patch_via_hdmi },
@@ -2588,6 +2589,7 @@ MODULE_ALIAS("snd-hda-codec-id:10de0042"
 MODULE_ALIAS("snd-hda-codec-id:10de0043");
 MODULE_ALIAS("snd-hda-codec-id:10de0044");
 MODULE_ALIAS("snd-hda-codec-id:10de0051");
+MODULE_ALIAS("snd-hda-codec-id:10de0060");
 MODULE_ALIAS("snd-hda-codec-id:10de0067");
 MODULE_ALIAS("snd-hda-codec-id:10de8001");
 MODULE_ALIAS("snd-hda-codec-id:11069f80");


