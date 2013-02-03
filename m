Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab3BCPK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:10:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34386 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754406Ab3BCO4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:46 -0500
Message-Id: <20130203144650.638930131@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Takashi Iwai <tiwai@suse.de>
Subject: [ 074/128] ALSA: hda/conexant - Correct vendor IDs for new codecs
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 2d825fd82eb765412a558a56e193b77117d56699 upstream.

Never trust datasheet...

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_conexant.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index a03fc33..3acb582 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4559,10 +4559,6 @@ static int patch_conexant_auto(struct hda_codec *codec)
  */
 
 static const struct hda_codec_preset snd_hda_preset_conexant[] = {
-	{ .id = 0x14f11510, .name = "CX20751/2",
-	  .patch = patch_conexant_auto },
-	{ .id = 0x14f11511, .name = "CX20753/4",
-	  .patch = patch_conexant_auto },
 	{ .id = 0x14f15045, .name = "CX20549 (Venice)",
 	  .patch = patch_cxt5045 },
 	{ .id = 0x14f15047, .name = "CX20551 (Waikiki)",
@@ -4597,11 +4593,15 @@ static const struct hda_codec_preset snd_hda_preset_conexant[] = {
 	  .patch = patch_conexant_auto },
 	{ .id = 0x14f150b9, .name = "CX20665",
 	  .patch = patch_conexant_auto },
+	{ .id = 0x14f1510f, .name = "CX20751/2",
+	  .patch = patch_conexant_auto },
+	{ .id = 0x14f15110, .name = "CX20751/2",
+	  .patch = patch_conexant_auto },
+	{ .id = 0x14f15111, .name = "CX20753/4",
+	  .patch = patch_conexant_auto },
 	{} /* terminator */
 };
 
-MODULE_ALIAS("snd-hda-codec-id:14f11510");
-MODULE_ALIAS("snd-hda-codec-id:14f11511");
 MODULE_ALIAS("snd-hda-codec-id:14f15045");
 MODULE_ALIAS("snd-hda-codec-id:14f15047");
 MODULE_ALIAS("snd-hda-codec-id:14f15051");
@@ -4619,6 +4619,9 @@ MODULE_ALIAS("snd-hda-codec-id:14f150ab");
 MODULE_ALIAS("snd-hda-codec-id:14f150ac");
 MODULE_ALIAS("snd-hda-codec-id:14f150b8");
 MODULE_ALIAS("snd-hda-codec-id:14f150b9");
+MODULE_ALIAS("snd-hda-codec-id:14f1510f");
+MODULE_ALIAS("snd-hda-codec-id:14f15110");
+MODULE_ALIAS("snd-hda-codec-id:14f15111");
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Conexant HD-audio codec");


