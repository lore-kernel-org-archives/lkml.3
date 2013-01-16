Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab3APQhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:37:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182Ab3APQFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:31 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 126/222] ALSA: hda - Fix pin configuration of HP Pavilion dv7
Date: Wed, 16 Jan 2013 13:55:26 -0200
Message-Id: <1358351822-7675-127-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8ae5865ec77c22462c736846a0679947a6953548 upstream.

Fix the quirk entry for HP Pavilion dv7 in order to make the bass
speaker working.

Reported-and-tested-by: Tomas Pospisek <tpo2@sourcepole.ch>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index b98aded..ca6b037 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1698,7 +1698,7 @@ static const struct snd_pci_quirk stac92hd83xxx_cfg_tbl[] = {
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1658,
 			  "HP", STAC_92HD83XXX_HP_cNB11_INTQUAD),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1659,
-			  "HP", STAC_92HD83XXX_HP_cNB11_INTQUAD),
+			  "HP Pavilion dv7", STAC_HP_DV7_4000),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x165A,
 			  "HP", STAC_92HD83XXX_HP_cNB11_INTQUAD),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x165B,
-- 
1.7.9.5

