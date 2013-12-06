Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab3LFXT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:19:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48831 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759685Ab3LFXTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:19:22 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 020/152] ALSA: hda - Add support of new codec ALC233
Date: Fri,  6 Dec 2013 15:09:04 -0800
Message-Id: <1386371476-2477-21-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 84dfd0ac231f69d70e100e712ad5e5f0092ad46b upstream.

It's compatible with ALC282.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d8c539b..5267e48 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6454,6 +6454,7 @@ static int patch_alc269(struct hda_codec *codec)
 	case 0x10ec0290:
 		spec->codec_variant = ALC269_TYPE_ALC280;
 		break;
+	case 0x10ec0233:
 	case 0x10ec0282:
 	case 0x10ec0283:
 		spec->codec_variant = ALC269_TYPE_ALC282;
@@ -7162,6 +7163,7 @@ static int patch_alc680(struct hda_codec *codec)
  */
 static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0221, .name = "ALC221", .patch = patch_alc269 },
+	{ .id = 0x10ec0233, .name = "ALC233", .patch = patch_alc269 },
 	{ .id = 0x10ec0260, .name = "ALC260", .patch = patch_alc260 },
 	{ .id = 0x10ec0262, .name = "ALC262", .patch = patch_alc262 },
 	{ .id = 0x10ec0267, .name = "ALC267", .patch = patch_alc268 },
-- 
1.8.3.2

