Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937226Ab3DJXQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:16:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937122Ab3DJWrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rainer Koenig <Rainer.Koenig@ts.fujitsu.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 14/64] ALSA: hda - Enabling Realtek ALC 671 codec
Date: Wed, 10 Apr 2013 15:46:11 -0700
Message-Id: <20130410224336.331001433@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rainer Koenig <Rainer.Koenig@ts.fujitsu.com>

commit 1d87caa69c04008e09f5ff47b5e6acb6116febc7 upstream.

* Added the device ID to the modalias list and assinged ALC662 patches
for it
* Added 4 port support for the device ID 0671 in alc662_parse_auto_config

Signed-off-by: Rainer Koenig <Rainer.Koenig@ts.fujitsu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6720,7 +6720,8 @@ static int alc662_parse_auto_config(stru
 	const hda_nid_t *ssids;
 
 	if (codec->vendor_id == 0x10ec0272 || codec->vendor_id == 0x10ec0663 ||
-	    codec->vendor_id == 0x10ec0665 || codec->vendor_id == 0x10ec0670)
+	    codec->vendor_id == 0x10ec0665 || codec->vendor_id == 0x10ec0670 ||
+	    codec->vendor_id == 0x10ec0671)
 		ssids = alc663_ssids;
 	else
 		ssids = alc662_ssids;
@@ -7173,6 +7174,7 @@ static const struct hda_codec_preset snd
 	{ .id = 0x10ec0665, .name = "ALC665", .patch = patch_alc662 },
 	{ .id = 0x10ec0668, .name = "ALC668", .patch = patch_alc662 },
 	{ .id = 0x10ec0670, .name = "ALC670", .patch = patch_alc662 },
+	{ .id = 0x10ec0671, .name = "ALC671", .patch = patch_alc662 },
 	{ .id = 0x10ec0680, .name = "ALC680", .patch = patch_alc680 },
 	{ .id = 0x10ec0880, .name = "ALC880", .patch = patch_alc880 },
 	{ .id = 0x10ec0882, .name = "ALC882", .patch = patch_alc882 },


