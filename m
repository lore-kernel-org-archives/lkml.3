Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965217AbaKLBny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:43:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965195AbaKLBnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:43:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Libin Yang <libin.yang@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: [PATCH 3.14 121/203] ALSA: hda - add codec ID for Braswell display audio codec
Date: Wed, 12 Nov 2014 10:16:31 +0900
Message-Id: <20141112011548.223555944@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Libin Yang <libin.yang@intel.com>

commit d1585c89cecdb513f68045e47ab76976524b5961 upstream.

This patch adds codec ID (0x80862883) and module alias for Braswell
display codec.

Signed-off-by: Libin Yang <libin.yang@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -3317,6 +3317,7 @@ static const struct hda_codec_preset snd
 { .id = 0x80862808, .name = "Broadwell HDMI",	.patch = patch_generic_hdmi },
 { .id = 0x80862880, .name = "CedarTrail HDMI",	.patch = patch_generic_hdmi },
 { .id = 0x80862882, .name = "Valleyview2 HDMI",	.patch = patch_generic_hdmi },
+{ .id = 0x80862883, .name = "Braswell HDMI",	.patch = patch_generic_hdmi },
 { .id = 0x808629fb, .name = "Crestline HDMI",	.patch = patch_generic_hdmi },
 {} /* terminator */
 };
@@ -3373,6 +3374,7 @@ MODULE_ALIAS("snd-hda-codec-id:80862807"
 MODULE_ALIAS("snd-hda-codec-id:80862808");
 MODULE_ALIAS("snd-hda-codec-id:80862880");
 MODULE_ALIAS("snd-hda-codec-id:80862882");
+MODULE_ALIAS("snd-hda-codec-id:80862883");
 MODULE_ALIAS("snd-hda-codec-id:808629fb");
 
 MODULE_LICENSE("GPL");


