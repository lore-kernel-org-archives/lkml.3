Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582Ab3LERl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:41:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38440 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab3LERiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:38:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 81/90] ALSA: hda/realtek - Set pcbeep amp for ALC668
Date: Thu,  5 Dec 2013 17:36:03 +0000
Message-Id: <1386264972-5399-82-git-send-email-luis.henriques@canonical.com>
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

commit 9ad54547cf6f4410eba83bb95dfd2a0966718d6d upstream.

Set the missing pcbeep default amp for ALC668.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 27d88ac..45f1b1c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6887,6 +6887,7 @@ static int patch_alc662(struct hda_codec *codec)
 		case 0x10ec0272:
 		case 0x10ec0663:
 		case 0x10ec0665:
+		case 0x10ec0668:
 			set_beep_amp(spec, 0x0b, 0x04, HDA_INPUT);
 			break;
 		case 0x10ec0273:
-- 
1.8.3.2

