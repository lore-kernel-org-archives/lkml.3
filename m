Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab3AXVPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:15:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:40100 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756854Ab3AXVOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tammy Yang <tammy.yang@canonical.com>,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 16/46] ALSA: hda - Fix mute led for another HP machine
Date: Thu, 24 Jan 2013 13:12:54 -0800
Message-Id: <20130124211141.914694747@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit e04340375a314166e14519fca9e5b9e9394b2d7a upstream.

This machine also has the "HP_Mute_LED_0_A" string in DMI information.

BugLink: https://bugs.launchpad.net/bugs/1096789
Tested-by: Tammy Yang <tammy.yang@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6211,6 +6211,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x0349, "Acer AOD260", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_MIC2_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x1972, "HP Pavilion 17", ALC269_FIXUP_MIC1_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x1977, "HP Pavilion 14", ALC269_FIXUP_MIC1_MUTE_LED),
 	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),


