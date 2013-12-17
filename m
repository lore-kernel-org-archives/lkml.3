Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab3LQSf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:35:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60914 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab3LQSOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 043/103] ALSA: hda - Another fixup for ASUS laptop with ALC660 codec
Date: Tue, 17 Dec 2013 18:12:32 +0000
Message-Id: <1387304012-23805-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit e7ca237bfcf6a288702cb95e94ab94f642ccad88 upstream.

ASUS Z35HL laptop also needs the very same fix as the previous one
that was applied to ASUS W7J.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=66231
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3fa47b3..9df1421 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6357,6 +6357,7 @@ static const struct alc_fixup alc861_fixups[] = {
 
 static const struct snd_pci_quirk alc861_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1253, "ASUS W7J", ALC660_FIXUP_ASUS_W7J),
+	SND_PCI_QUIRK(0x1043, 0x1263, "ASUS Z35HL", ALC660_FIXUP_ASUS_W7J),
 	SND_PCI_QUIRK(0x1043, 0x1393, "ASUS A6Rp", ALC861_FIXUP_ASUS_A6RP),
 	SND_PCI_QUIRK_VENDOR(0x1043, "ASUS laptop", ALC861_FIXUP_AMP_VREF_0F),
 	SND_PCI_QUIRK(0x1462, 0x7254, "HP DX2200", ALC861_FIXUP_NO_JACK_DETECT),
-- 
1.8.3.2

