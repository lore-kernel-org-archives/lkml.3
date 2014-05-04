Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbaEDQ4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:56:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaEDPlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 027/158] ALSA: hda/realtek - Add support of ALC288 codec
Date: Sun,  4 May 2014 11:38:56 -0400
Message-Id: <20140504154033.725561795@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 7c66593286bcd153e4868383e675673a27071bd5 upstream.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4708,6 +4708,7 @@ static int patch_alc269(struct hda_codec
 		spec->codec_variant = ALC269_TYPE_ALC285;
 		break;
 	case 0x10ec0286:
+	case 0x10ec0288:
 		spec->codec_variant = ALC269_TYPE_ALC286;
 		break;
 	case 0x10ec0255:
@@ -5514,6 +5515,7 @@ static const struct hda_codec_preset snd
 	{ .id = 0x10ec0284, .name = "ALC284", .patch = patch_alc269 },
 	{ .id = 0x10ec0285, .name = "ALC285", .patch = patch_alc269 },
 	{ .id = 0x10ec0286, .name = "ALC286", .patch = patch_alc269 },
+	{ .id = 0x10ec0288, .name = "ALC288", .patch = patch_alc269 },
 	{ .id = 0x10ec0290, .name = "ALC290", .patch = patch_alc269 },
 	{ .id = 0x10ec0292, .name = "ALC292", .patch = patch_alc269 },
 	{ .id = 0x10ec0293, .name = "ALC293", .patch = patch_alc269 },


