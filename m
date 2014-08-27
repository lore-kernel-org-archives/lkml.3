Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbaH0EWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:22:06 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:55292 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaH0EWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:22:04 -0400
From: Konstantinos Tsimpoukas <kostaslinuxxx@gmail.com>
To: Konstantinos Tsimpoukas <kostaslinuxxx@gmail.com>,
        <alsa-devel@alsa-project.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <linux-sound@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ice1712: Replacing hex with #defines
Date: Tue, 26 Aug 2014 23:21:48 -0500
Message-Id: <1409113308-4671-1-git-send-email-kostaslinuxxx@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds to te readability of the ice1712 driver.

Signed-off-by: Konstantinos Tsimpoukas <kostaslinuxxx@gmail.com>
---
 sound/pci/ice1712/ice1712.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 87f7fc4..206ed2c 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2528,7 +2528,7 @@ static int snd_ice1712_free(struct snd_ice1712 *ice)
 	if (!ice->port)
 		goto __hw_end;
 	/* mask all interrupts */
-	outb(0xc0, ICEMT(ice, IRQ));
+	outb(ICE1712_MULTI_CAPTURE | ICE1712_MULTI_PLAYBACK, ICEMT(ice, IRQ));
 	outb(0xff, ICEREG(ice, IRQMASK));
 	/* --- */
 __hw_end:
-- 
1.9.1

