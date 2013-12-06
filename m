Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab3LFXZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:25:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49017 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162447Ab3LFXUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:49 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 066/152] ALSA: hda - Add support for CX20952
Date: Fri,  6 Dec 2013 15:09:50 -0800
Message-Id: <1386371476-2477-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8f42d7698751a45cd9f7134a5da49bc5b6206179 upstream.

It's a superset of the existing CX2075x codecs, so we can reuse the
existing parser code.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_conexant.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 09fae16..c631e08 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4642,6 +4642,8 @@ static const struct hda_codec_preset snd_hda_preset_conexant[] = {
 	  .patch = patch_conexant_auto },
 	{ .id = 0x14f15115, .name = "CX20757",
 	  .patch = patch_conexant_auto },
+	{ .id = 0x14f151d7, .name = "CX20952",
+	  .patch = patch_conexant_auto },
 	{} /* terminator */
 };
 
@@ -4668,6 +4670,7 @@ MODULE_ALIAS("snd-hda-codec-id:14f15111");
 MODULE_ALIAS("snd-hda-codec-id:14f15113");
 MODULE_ALIAS("snd-hda-codec-id:14f15114");
 MODULE_ALIAS("snd-hda-codec-id:14f15115");
+MODULE_ALIAS("snd-hda-codec-id:14f151d7");
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Conexant HD-audio codec");
-- 
1.8.3.2

