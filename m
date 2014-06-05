Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaFEEV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:21:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaFEEVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 126/214] ALSA: hda/conexant - Correct vendor IDs for new codecs
Date: Wed,  4 Jun 2014 21:18:09 -0700
Message-Id: <20140605041656.640178195@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 2d825fd82eb765412a558a56e193b77117d56699 upstream.

Never trust datasheet...

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4572,10 +4572,6 @@ static int patch_conexant_auto(struct hd
  */
 
 static const struct hda_codec_preset snd_hda_preset_conexant[] = {
-	{ .id = 0x14f11510, .name = "CX20751/2",
-	  .patch = patch_conexant_auto },
-	{ .id = 0x14f11511, .name = "CX20753/4",
-	  .patch = patch_conexant_auto },
 	{ .id = 0x14f15045, .name = "CX20549 (Venice)",
 	  .patch = patch_cxt5045 },
 	{ .id = 0x14f15047, .name = "CX20551 (Waikiki)",
@@ -4610,11 +4606,15 @@ static const struct hda_codec_preset snd
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
@@ -4632,6 +4632,9 @@ MODULE_ALIAS("snd-hda-codec-id:14f150ab"
 MODULE_ALIAS("snd-hda-codec-id:14f150ac");
 MODULE_ALIAS("snd-hda-codec-id:14f150b8");
 MODULE_ALIAS("snd-hda-codec-id:14f150b9");
+MODULE_ALIAS("snd-hda-codec-id:14f1510f");
+MODULE_ALIAS("snd-hda-codec-id:14f15110");
+MODULE_ALIAS("snd-hda-codec-id:14f15111");
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Conexant HD-audio codec");


