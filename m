Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab3LERmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:42:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38435 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab3LERiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:38:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 80/90] ALSA: hda/realtek - Add support of ALC231 codec
Date: Thu,  5 Dec 2013 17:36:02 +0000
Message-Id: <1386264972-5399-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit ba4c4d0a9021ab034554d532a98133d668b87599 upstream.

It's compatible with ALC269.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 72694bd..27d88ac 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6944,6 +6944,7 @@ static int patch_alc680(struct hda_codec *codec)
  */
 static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0221, .name = "ALC221", .patch = patch_alc269 },
+	{ .id = 0x10ec0231, .name = "ALC231", .patch = patch_alc269 },
 	{ .id = 0x10ec0260, .name = "ALC260", .patch = patch_alc260 },
 	{ .id = 0x10ec0262, .name = "ALC262", .patch = patch_alc262 },
 	{ .id = 0x10ec0267, .name = "ALC267", .patch = patch_alc268 },
-- 
1.8.3.2

