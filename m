Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbaFEEqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:46:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbaFEEVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 128/214] ALSA: hda - Add support for CX20952
Date: Wed,  4 Jun 2014 21:18:11 -0700
Message-Id: <20140605041656.908424964@linuxfoundation.org>
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

commit 8f42d7698751a45cd9f7134a5da49bc5b6206179 upstream.

It's a superset of the existing CX2075x codecs, so we can reuse the
existing parser code.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4618,6 +4618,8 @@ static const struct hda_codec_preset snd
 	  .patch = patch_conexant_auto },
 	{ .id = 0x14f15115, .name = "CX20757",
 	  .patch = patch_conexant_auto },
+	{ .id = 0x14f151d7, .name = "CX20952",
+	  .patch = patch_conexant_auto },
 	{} /* terminator */
 };
 
@@ -4644,6 +4646,7 @@ MODULE_ALIAS("snd-hda-codec-id:14f15111"
 MODULE_ALIAS("snd-hda-codec-id:14f15113");
 MODULE_ALIAS("snd-hda-codec-id:14f15114");
 MODULE_ALIAS("snd-hda-codec-id:14f15115");
+MODULE_ALIAS("snd-hda-codec-id:14f151d7");
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Conexant HD-audio codec");


