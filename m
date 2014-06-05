Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbaFEErk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:47:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbaFEEVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Kaechele <felix@fetzig.org>, Takashi Iwai <tiwai@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 123/214] ALSA: hda - Add inverted internal mic quirk for Lenovo IdeaPad U310
Date: Wed,  4 Jun 2014 21:18:06 -0700
Message-Id: <20140605041656.234571431@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Kaechele <felix@fetzig.org>

commit e4db0952e542090c605fd41d31d761f1b4624f4a upstream.

The Lenovo IdeaPad U310 has an internal mic where the right channel
is phase inverted.

Signed-off-by: Felix Kaechele <felix@fetzig.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4477,6 +4477,7 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK(0x17aa, 0x21ce, "Lenovo T420", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21cf, "Lenovo T520", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
+	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
 	{}
 };


