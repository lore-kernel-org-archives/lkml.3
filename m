Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbaF3MsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:48:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754211AbaF3Mak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:40 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 075/181] ALSA: hda/realtek - Add support of ALC891 codec
Date: Mon, 30 Jun 2014 13:51:36 +0200
Message-Id: <1f55569fd4edd999a3388e04ed347256470ece4b.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b6c5fbad16aa5026f508093a8d651c25e1cb6179 upstream.

New codec support for ALC891.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 23971aa25fef..e19001f9203c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5134,6 +5134,7 @@ static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0670, .name = "ALC670", .patch = patch_alc662 },
 	{ .id = 0x10ec0671, .name = "ALC671", .patch = patch_alc662 },
 	{ .id = 0x10ec0680, .name = "ALC680", .patch = patch_alc680 },
+	{ .id = 0x10ec0867, .name = "ALC891", .patch = patch_alc882 },
 	{ .id = 0x10ec0880, .name = "ALC880", .patch = patch_alc880 },
 	{ .id = 0x10ec0882, .name = "ALC882", .patch = patch_alc882 },
 	{ .id = 0x10ec0883, .name = "ALC883", .patch = patch_alc882 },
-- 
2.0.0

