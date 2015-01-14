Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbbANL6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:58:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41089 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbbANL6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:58:36 -0500
From: Colin King <colin.king@canonical.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: snd-usb-usx2y: fix incorrect indentation on if statement
Date: Wed, 14 Jan 2015 11:57:33 +0000
Message-Id: <1421236653-4627-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Minor style issue, statement needs an extra tab indentation
on the if statement.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 sound/usb/usx2y/usbusx2yaudio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
index 61d5dc2..dd40ca9 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -166,7 +166,7 @@ static int usX2Y_urb_play_prepare(struct snd_usX2Y_substream *subs,
 			/* set the buffer pointer */
 			urb->transfer_buffer = runtime->dma_area + subs->hwptr * usX2Y->stride;
 			if ((subs->hwptr += count) >= runtime->buffer_size)
-			subs->hwptr -= runtime->buffer_size;			
+				subs->hwptr -= runtime->buffer_size;
 		}
 	else
 		urb->transfer_buffer = subs->tmpbuf;
-- 
2.1.4

