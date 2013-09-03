Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145Ab3ICQ3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:29:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46685 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019Ab3ICQ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:29:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 23/58] ALSA: hda - Add a fixup for Gateway LT27
Date: Tue,  3 Sep 2013 09:23:27 -0700
Message-Id: <1378225442-20654-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1801928e0f99d94c55e33c584c5eb2ff5e246ee6 upstream.

Gateway LT27 needs a fixup for the inverted digital mic.

Reported-by: "Nathanael D. Noblet" <nathanael@gnat.ca>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7f45d48..a7f0d7f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6932,6 +6932,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x0308, "Acer Aspire 8942G", ALC662_FIXUP_ASPIRE),
 	SND_PCI_QUIRK(0x1025, 0x031c, "Gateway NV79", ALC662_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x1025, 0x0349, "eMachines eM250", ALC662_FIXUP_INV_DMIC),
+	SND_PCI_QUIRK(0x1025, 0x034a, "Gateway LT27", ALC662_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
 	SND_PCI_QUIRK(0x1043, 0x8469, "ASUS mobo", ALC662_FIXUP_NO_JACK_DETECT),
-- 
1.8.1.2

