Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab3KIHq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:46:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab3KIGtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:49:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.4 14/26] ALSA: hda - Add a fixup for ASUS N76VZ
Date: Fri,  8 Nov 2013 22:51:43 -0800
Message-Id: <20131109065051.209766390@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065050.089866597@linuxfoundation.org>
References: <20131109065050.089866597@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6fc16e58adf50c0f1e4478538983fb5ff6f453d4 upstream.

ASUS N76VZ needs the same fixup as N56VZ for supporting the boost
speaker.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=846529
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6833,6 +6833,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
 	SND_PCI_QUIRK(0x1043, 0x1477, "ASUS N56VZ", ALC662_FIXUP_ASUS_MODE4),
+	SND_PCI_QUIRK(0x1043, 0x1bf3, "ASUS N76VZ", ALC662_FIXUP_ASUS_MODE4),
 	SND_PCI_QUIRK(0x1043, 0x8469, "ASUS mobo", ALC662_FIXUP_NO_JACK_DETECT),
 	SND_PCI_QUIRK(0x105b, 0x0cd6, "Foxconn", ALC662_FIXUP_ASUS_MODE2),
 	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),


