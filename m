Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965002AbaGCJXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:23:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52004 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964955AbaGCJXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 098/198] ALSA: hda/realtek - Add support of ALC891 codec
Date: Thu,  3 Jul 2014 10:19:01 +0100
Message-Id: <1404379241-8590-99-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit b6c5fbad16aa5026f508093a8d651c25e1cb6179 upstream.

New codec support for ALC891.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index cdb307f2e028..e486d1300b97 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4851,6 +4851,7 @@ static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0670, .name = "ALC670", .patch = patch_alc662 },
 	{ .id = 0x10ec0671, .name = "ALC671", .patch = patch_alc662 },
 	{ .id = 0x10ec0680, .name = "ALC680", .patch = patch_alc680 },
+	{ .id = 0x10ec0867, .name = "ALC891", .patch = patch_alc882 },
 	{ .id = 0x10ec0880, .name = "ALC880", .patch = patch_alc880 },
 	{ .id = 0x10ec0882, .name = "ALC882", .patch = patch_alc882 },
 	{ .id = 0x10ec0883, .name = "ALC883", .patch = patch_alc882 },
-- 
1.9.1

