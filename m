Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab3BEWJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:09:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47931 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab3BEWJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:09:08 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 24/93] ALSA: hda - Add Conexant CX20755/20756/20757 codec IDs
Date: Tue,  5 Feb 2013 20:06:13 -0200
Message-Id: <1360102042-10732-25-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 42c364ace52ae6b4699105b39f2559c256b6cd4c upstream.

These are just compatible with other CX2075x codecs.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_conexant.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 908fc7f..2682b3d 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4588,6 +4588,12 @@ static const struct hda_codec_preset snd_hda_preset_conexant[] = {
 	  .patch = patch_conexant_auto },
 	{ .id = 0x14f15111, .name = "CX20753/4",
 	  .patch = patch_conexant_auto },
+	{ .id = 0x14f15113, .name = "CX20755",
+	  .patch = patch_conexant_auto },
+	{ .id = 0x14f15114, .name = "CX20756",
+	  .patch = patch_conexant_auto },
+	{ .id = 0x14f15115, .name = "CX20757",
+	  .patch = patch_conexant_auto },
 	{} /* terminator */
 };
 
@@ -4611,6 +4617,9 @@ MODULE_ALIAS("snd-hda-codec-id:14f150b9");
 MODULE_ALIAS("snd-hda-codec-id:14f1510f");
 MODULE_ALIAS("snd-hda-codec-id:14f15110");
 MODULE_ALIAS("snd-hda-codec-id:14f15111");
+MODULE_ALIAS("snd-hda-codec-id:14f15113");
+MODULE_ALIAS("snd-hda-codec-id:14f15114");
+MODULE_ALIAS("snd-hda-codec-id:14f15115");
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Conexant HD-audio codec");
-- 
1.7.9.5

