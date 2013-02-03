Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3BCPKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:10:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34393 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754517Ab3BCO4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:49 -0500
Message-Id: <20130203144650.726162920@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Takashi Iwai <tiwai@suse.de>
Subject: [ 075/128] ALSA: hda - Add Conexant CX20755/20756/20757 codec IDs
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

commit 42c364ace52ae6b4699105b39f2559c256b6cd4c upstream.

These are just compatible with other CX2075x codecs.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_conexant.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index dd798c3..009b77a 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4636,6 +4636,12 @@ static const struct hda_codec_preset snd_hda_preset_conexant[] = {
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
 
@@ -4659,6 +4665,9 @@ MODULE_ALIAS("snd-hda-codec-id:14f150b9");
 MODULE_ALIAS("snd-hda-codec-id:14f1510f");
 MODULE_ALIAS("snd-hda-codec-id:14f15110");
 MODULE_ALIAS("snd-hda-codec-id:14f15111");
+MODULE_ALIAS("snd-hda-codec-id:14f15113");
+MODULE_ALIAS("snd-hda-codec-id:14f15114");
+MODULE_ALIAS("snd-hda-codec-id:14f15115");
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Conexant HD-audio codec");


