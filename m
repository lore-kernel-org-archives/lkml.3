Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbaFJUhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:37:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34883 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbaFJTq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:46:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 011/160] ALSA: hda/realtek - Add support of ALC288 codec
Date: Tue, 10 Jun 2014 12:44:11 -0700
Message-Id: <1402429600-20477-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 7c66593286bcd153e4868383e675673a27071bd5 upstream.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index ad45ce4..93b95b8 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4648,6 +4648,7 @@ static int patch_alc269(struct hda_codec *codec)
 		spec->codec_variant = ALC269_TYPE_ALC285;
 		break;
 	case 0x10ec0286:
+	case 0x10ec0288:
 		spec->codec_variant = ALC269_TYPE_ALC286;
 		break;
 	case 0x10ec0255:
@@ -5454,6 +5455,7 @@ static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0284, .name = "ALC284", .patch = patch_alc269 },
 	{ .id = 0x10ec0285, .name = "ALC285", .patch = patch_alc269 },
 	{ .id = 0x10ec0286, .name = "ALC286", .patch = patch_alc269 },
+	{ .id = 0x10ec0288, .name = "ALC288", .patch = patch_alc269 },
 	{ .id = 0x10ec0290, .name = "ALC290", .patch = patch_alc269 },
 	{ .id = 0x10ec0292, .name = "ALC292", .patch = patch_alc269 },
 	{ .id = 0x10ec0293, .name = "ALC293", .patch = patch_alc269 },
-- 
1.9.1

