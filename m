Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616Ab3K0BXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:23:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab3K0A7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 049/116] ALSA: hda - Add support for CX20952
Date: Tue, 26 Nov 2013 16:57:02 -0800
Message-Id: <20131127005740.339526462@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8f42d7698751a45cd9f7134a5da49bc5b6206179 upstream.

It's a superset of the existing CX2075x codecs, so we can reuse the
existing parser code.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3568,6 +3568,8 @@ static const struct hda_codec_preset snd
 	  .patch = patch_conexant_auto },
 	{ .id = 0x14f15115, .name = "CX20757",
 	  .patch = patch_conexant_auto },
+	{ .id = 0x14f151d7, .name = "CX20952",
+	  .patch = patch_conexant_auto },
 	{} /* terminator */
 };
 
@@ -3594,6 +3596,7 @@ MODULE_ALIAS("snd-hda-codec-id:14f15111"
 MODULE_ALIAS("snd-hda-codec-id:14f15113");
 MODULE_ALIAS("snd-hda-codec-id:14f15114");
 MODULE_ALIAS("snd-hda-codec-id:14f15115");
+MODULE_ALIAS("snd-hda-codec-id:14f151d7");
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Conexant HD-audio codec");


