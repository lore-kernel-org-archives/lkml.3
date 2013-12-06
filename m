Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162345Ab3LFNLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:11:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44767 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162132Ab3LFNFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:05:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 254/272] ALSA: hda - Add support for CX20952
Date: Fri,  6 Dec 2013 12:59:03 +0000
Message-Id: <1386334761-25517-255-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8f42d7698751a45cd9f7134a5da49bc5b6206179 upstream.

It's a superset of the existing CX2075x codecs, so we can reuse the
existing parser code.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_conexant.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index ac7697e..8311c63 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3491,6 +3491,8 @@ static const struct hda_codec_preset snd_hda_preset_conexant[] = {
 	  .patch = patch_conexant_auto },
 	{ .id = 0x14f15115, .name = "CX20757",
 	  .patch = patch_conexant_auto },
+	{ .id = 0x14f151d7, .name = "CX20952",
+	  .patch = patch_conexant_auto },
 	{} /* terminator */
 };
 
@@ -3517,6 +3519,7 @@ MODULE_ALIAS("snd-hda-codec-id:14f15111");
 MODULE_ALIAS("snd-hda-codec-id:14f15113");
 MODULE_ALIAS("snd-hda-codec-id:14f15114");
 MODULE_ALIAS("snd-hda-codec-id:14f15115");
+MODULE_ALIAS("snd-hda-codec-id:14f151d7");
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Conexant HD-audio codec");
-- 
1.8.3.2

