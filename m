Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaDAQVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:21:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44699 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaDAQQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:16:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marius Knaust <marius.knaust@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 37/86] ALSA: hda - Added inverted digital-mic handling for Acer TravelMate 8371
Date: Tue,  1 Apr 2014 09:07:50 -0700
Message-Id: <1396368519-12728-38-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marius Knaust <marius.knaust@gmail.com>

commit a6b92b6650d010d58b6e6fe42c6271266e0b1134 upstream.

Signed-off-by: Marius Knaust <marius.knaust@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e2e7868..1ff8cc5 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6323,6 +6323,7 @@ static const struct alc_fixup alc269_fixups[] = {
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
+	SND_PCI_QUIRK(0x1025, 0x0283, "Acer TravelMate 8371", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x029b, "Acer 1810TZ", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x0349, "Acer AOD260", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_MIC2_MUTE_LED),
-- 
1.8.3.2

