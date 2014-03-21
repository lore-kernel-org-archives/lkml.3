Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966491AbaCUAlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:41:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965850AbaCUAIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:08:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marius Knaust <marius.knaust@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 32/85] ALSA: hda - Added inverted digital-mic handling for Acer TravelMate 8371
Date: Thu, 20 Mar 2014 17:09:35 -0700
Message-Id: <20140321000603.193489884@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marius Knaust <marius.knaust@gmail.com>

commit a6b92b6650d010d58b6e6fe42c6271266e0b1134 upstream.

Signed-off-by: Marius Knaust <marius.knaust@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3648,6 +3648,7 @@ static const struct hda_fixup alc269_fix
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
+	SND_PCI_QUIRK(0x1025, 0x0283, "Acer TravelMate 8371", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x029b, "Acer 1810TZ", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x0349, "Acer AOD260", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1028, 0x05bd, "Dell", ALC269_FIXUP_DELL2_MIC_NO_PRESENCE),


