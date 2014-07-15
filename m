Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbaGOVgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:36:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54473 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759351AbaGOVgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:36:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 136/198] ALSA: hda/realtek - Add more entry for enable HP mute led
Date: Tue, 15 Jul 2014 14:30:06 -0700
Message-Id: <1405459868-15089-137-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 8a02b164d4bfac108bfe37e98108bff1e062bd3d upstream.

More HP machine need mute led support.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 5724c7e..6cbbd98 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4429,14 +4429,24 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x1983, "HP Pavilion", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x218b, "HP", ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED),
 	/* ALC282 */
+	SND_PCI_QUIRK(0x103c, 0x220d, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
+	SND_PCI_QUIRK(0x103c, 0x220e, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x220f, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
+	SND_PCI_QUIRK(0x103c, 0x2210, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
+	SND_PCI_QUIRK(0x103c, 0x2211, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
+	SND_PCI_QUIRK(0x103c, 0x2212, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x2213, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
+	SND_PCI_QUIRK(0x103c, 0x2214, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x2266, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x2267, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x2268, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x2269, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x226a, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x226b, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
+	SND_PCI_QUIRK(0x103c, 0x226c, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
+	SND_PCI_QUIRK(0x103c, 0x226d, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
+	SND_PCI_QUIRK(0x103c, 0x226e, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
+	SND_PCI_QUIRK(0x103c, 0x226f, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x227a, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x227b, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x229e, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
@@ -4475,6 +4485,10 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x22c8, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x22c3, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x22c4, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
+	SND_PCI_QUIRK(0x103c, 0x2334, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
+	SND_PCI_QUIRK(0x103c, 0x2335, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
+	SND_PCI_QUIRK(0x103c, 0x2336, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
+	SND_PCI_QUIRK(0x103c, 0x2337, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK_VENDOR(0x103c, "HP", ALC269_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
1.9.1

