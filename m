Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbaGHTTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:19:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54306 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755745AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>,
        "Kailang Yang" <kailang@realtek.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.674053061@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 061/125] ALSA: hda/realtek - Add support of ALC891 codec
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit b6c5fbad16aa5026f508093a8d651c25e1cb6179 upstream.

New codec support for ALC891.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6056,6 +6056,7 @@ static const struct hda_codec_preset snd
 	{ .id = 0x10ec0670, .name = "ALC670", .patch = patch_alc662 },
 	{ .id = 0x10ec0671, .name = "ALC671", .patch = patch_alc662 },
 	{ .id = 0x10ec0680, .name = "ALC680", .patch = patch_alc680 },
+	{ .id = 0x10ec0867, .name = "ALC891", .patch = patch_alc882 },
 	{ .id = 0x10ec0880, .name = "ALC880", .patch = patch_alc880 },
 	{ .id = 0x10ec0882, .name = "ALC882", .patch = patch_alc882 },
 	{ .id = 0x10ec0883, .name = "ALC883", .patch = patch_alc882 },

