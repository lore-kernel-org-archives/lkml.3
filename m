Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaL1Net (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 08:34:49 -0500
Received: from mail.ludd.ltu.se ([130.240.16.30]:49640 "EHLO mail.ludd.ltu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaL1Ner (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 08:34:47 -0500
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Dec 2014 08:34:47 EST
From: Jonas Lundqvist <jonas@gannon.se>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jonas Lundqvist <jonas@gannon.se>
Subject: [PATCH] Staging: line6: remove spaces before commas.
Date: Sun, 28 Dec 2014 14:26:46 +0100
Message-Id: <1419773206-18729-1-git-send-email-jonas@gannon.se>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed three errors in pcm.h found by checkpatch.pl.

Signed-off-by: Jonas Lundqvist <jonas@gannon.se>
---
 drivers/staging/line6/pcm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/line6/pcm.h b/drivers/staging/line6/pcm.h
index 6aa0d46..5d87934 100644
--- a/drivers/staging/line6/pcm.h
+++ b/drivers/staging/line6/pcm.h
@@ -145,21 +145,21 @@ enum {
 	    LINE6_BIT_PCM_IMPULSE_PLAYBACK_BUFFER |
 #endif
 	    LINE6_BIT_PCM_ALSA_PLAYBACK_BUFFER |
-	    LINE6_BIT_PCM_MONITOR_PLAYBACK_BUFFER ,
+	    LINE6_BIT_PCM_MONITOR_PLAYBACK_BUFFER,
 
 	LINE6_BITS_PLAYBACK_STREAM =
 #ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
 	    LINE6_BIT_PCM_IMPULSE_PLAYBACK_STREAM |
 #endif
 	    LINE6_BIT_PCM_ALSA_PLAYBACK_STREAM |
-	    LINE6_BIT_PCM_MONITOR_PLAYBACK_STREAM ,
+	    LINE6_BIT_PCM_MONITOR_PLAYBACK_STREAM,
 
 	LINE6_BITS_CAPTURE_BUFFER =
 #ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
 	    LINE6_BIT_PCM_IMPULSE_CAPTURE_BUFFER |
 #endif
 	    LINE6_BIT_PCM_ALSA_CAPTURE_BUFFER |
-	    LINE6_BIT_PCM_MONITOR_CAPTURE_BUFFER ,
+	    LINE6_BIT_PCM_MONITOR_CAPTURE_BUFFER,
 
 	LINE6_BITS_CAPTURE_STREAM =
 #ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
-- 
2.1.4

