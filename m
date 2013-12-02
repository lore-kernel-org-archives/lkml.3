Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab3LBTo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:44:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab3LBTSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 159/212] ALSA: hda/realtek - Add support of ALC231 codec
Date: Mon,  2 Dec 2013 11:15:50 -0800
Message-Id: <20131202191305.449003907@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit ba4c4d0a9021ab034554d532a98133d668b87599 upstream.

It's compatible with ALC269.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4922,6 +4922,7 @@ static int patch_alc680(struct hda_codec
  */
 static const struct hda_codec_preset snd_hda_preset_realtek[] = {
 	{ .id = 0x10ec0221, .name = "ALC221", .patch = patch_alc269 },
+	{ .id = 0x10ec0231, .name = "ALC231", .patch = patch_alc269 },
 	{ .id = 0x10ec0233, .name = "ALC233", .patch = patch_alc269 },
 	{ .id = 0x10ec0255, .name = "ALC255", .patch = patch_alc269 },
 	{ .id = 0x10ec0260, .name = "ALC260", .patch = patch_alc260 },


