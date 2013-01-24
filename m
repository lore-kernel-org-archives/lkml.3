Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab3AXVcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:32:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:40214 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756653Ab3AXVO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 17/46] ALSA: hda - Add Conexant CX20755/20756/20757 codec IDs
Date: Thu, 24 Jan 2013 13:12:55 -0800
Message-Id: <20130124211142.308917636@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 42c364ace52ae6b4699105b39f2559c256b6cd4c upstream.

These are just compatible with other CX2075x codecs.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4580,6 +4580,12 @@ static const struct hda_codec_preset snd
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
 
@@ -4603,6 +4609,9 @@ MODULE_ALIAS("snd-hda-codec-id:14f150b9"
 MODULE_ALIAS("snd-hda-codec-id:14f1510f");
 MODULE_ALIAS("snd-hda-codec-id:14f15110");
 MODULE_ALIAS("snd-hda-codec-id:14f15111");
+MODULE_ALIAS("snd-hda-codec-id:14f15113");
+MODULE_ALIAS("snd-hda-codec-id:14f15114");
+MODULE_ALIAS("snd-hda-codec-id:14f15115");
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Conexant HD-audio codec");


