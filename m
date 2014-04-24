Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaDXJY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:24:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47021 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbaDXIz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 153/182] ALSA: hda/realtek - Add support of ALC288 codec
Date: Thu, 24 Apr 2014 09:51:18 +0100
Message-Id: <1398329507-5911-154-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 7c66593286bcd153e4868383e675673a27071bd5 upstream.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9716e68..78a42ab 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4078,6 +4078,7 @@ static int patch_alc269(struct hda_codec *codec)
 		spec->codec_variant = ALC269_TYPE_ALC284;
 		break;
 	case 0x10ec0286:
+	case 0x10ec0288:
 		spec->codec_variant = ALC269_TYPE_ALC286;
 		break;
 	case 0x10ec0255:
@@ -4830,6 +4831,7 @@ static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0283, .name = "ALC283", .patch = patch_alc269 },
 	{ .id = 0x10ec0284, .name = "ALC284", .patch = patch_alc269 },
 	{ .id = 0x10ec0286, .name = "ALC286", .patch = patch_alc269 },
+	{ .id = 0x10ec0288, .name = "ALC288", .patch = patch_alc269 },
 	{ .id = 0x10ec0290, .name = "ALC290", .patch = patch_alc269 },
 	{ .id = 0x10ec0292, .name = "ALC292", .patch = patch_alc269 },
 	{ .id = 0x10ec0861, .rev = 0x100340, .name = "ALC660",
-- 
1.9.1

