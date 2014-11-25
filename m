Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaKYLsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:48:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58265 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbaKYKlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Libin Yang <libin.yang@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 061/254] ALSA: hda - add codec ID for Braswell display audio codec
Date: Tue, 25 Nov 2014 10:36:51 +0000
Message-Id: <1416912004-5928-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Libin Yang <libin.yang@intel.com>

commit d1585c89cecdb513f68045e47ab76976524b5961 upstream.

This patch adds codec ID (0x80862883) and module alias for Braswell
display codec.

Signed-off-by: Libin Yang <libin.yang@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index ddd825bce575..210d411c0698 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -3358,6 +3358,7 @@ static const struct hda_codec_preset snd_hda_preset_hdmi[] = {
 { .id = 0x80862808, .name = "Broadwell HDMI",	.patch = patch_generic_hdmi },
 { .id = 0x80862880, .name = "CedarTrail HDMI",	.patch = patch_generic_hdmi },
 { .id = 0x80862882, .name = "Valleyview2 HDMI",	.patch = patch_generic_hdmi },
+{ .id = 0x80862883, .name = "Braswell HDMI",	.patch = patch_generic_hdmi },
 { .id = 0x808629fb, .name = "Crestline HDMI",	.patch = patch_generic_hdmi },
 {} /* terminator */
 };
@@ -3417,6 +3418,7 @@ MODULE_ALIAS("snd-hda-codec-id:80862807");
 MODULE_ALIAS("snd-hda-codec-id:80862808");
 MODULE_ALIAS("snd-hda-codec-id:80862880");
 MODULE_ALIAS("snd-hda-codec-id:80862882");
+MODULE_ALIAS("snd-hda-codec-id:80862883");
 MODULE_ALIAS("snd-hda-codec-id:808629fb");
 
 MODULE_LICENSE("GPL");
-- 
2.1.0

