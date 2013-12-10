Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3LJIBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:01:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab3LJIBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:01:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 02/62] ALSA: hda - Another fixup for ASUS laptop with ALC660 codec
Date: Tue, 10 Dec 2013 00:00:33 -0800
Message-Id: <20131210080057.584088971@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit e7ca237bfcf6a288702cb95e94ab94f642ccad88 upstream.

ASUS Z35HL laptop also needs the very same fix as the previous one
that was applied to ASUS W7J.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=66231
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4331,6 +4331,7 @@ static const struct hda_fixup alc861_fix
 
 static const struct snd_pci_quirk alc861_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1253, "ASUS W7J", ALC660_FIXUP_ASUS_W7J),
+	SND_PCI_QUIRK(0x1043, 0x1263, "ASUS Z35HL", ALC660_FIXUP_ASUS_W7J),
 	SND_PCI_QUIRK(0x1043, 0x1393, "ASUS A6Rp", ALC861_FIXUP_ASUS_A6RP),
 	SND_PCI_QUIRK_VENDOR(0x1043, "ASUS laptop", ALC861_FIXUP_AMP_VREF_0F),
 	SND_PCI_QUIRK(0x1462, 0x7254, "HP DX2200", ALC861_FIXUP_NO_JACK_DETECT),


