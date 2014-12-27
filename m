Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135AbaL0GAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 01:00:25 -0500
Received: from mout.gmx.com ([74.208.4.201]:49271 "EHLO mout.gmx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbaL0GAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 01:00:24 -0500
From: Damon Swayn <damon.swayn@null.net>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Damon Swayn <damon.swayn@null.net>
Subject: [PATCH] Staging: line6: Updated comma spacing to fit within coding style
Date: Sat, 27 Dec 2014 17:00:10 +1100
Message-Id: <1419660010-7694-1-git-send-email-damon.swayn@null.net>
X-Mailer: git-send-email 2.1.0
X-Provags-ID: V03:K0:xpopVyRZHQ7nXigyGYIYRFPVrjMOGulAchj0dOTt8yEktcRKmi2
 Ver5fKOIdKSDqLekN1yygTQI0Gj7XEdr7YFd6lrECHnT++2+Vyj7ixLkW13Sag4X6CkRCS2
 0sdLJyEv3aJ7Vz5PC8RZ/GvS3W2PZQcYFwlbTtVhW5/XlKuChTGmn8t2ASZEEUueeqU9QvY
 Snq0rMg+jeDBOiWp8JgjA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue reported by checkpatch surrounding the
spacing of comma's

Signed-off-by: Damon Swayn <damon.swayn@null.net>
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
2.1.0

