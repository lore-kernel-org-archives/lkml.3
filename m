Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaL2VMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 16:12:17 -0500
Received: from mail.ludd.ltu.se ([130.240.16.30]:38121 "EHLO mail.ludd.ltu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbaL2VMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 16:12:17 -0500
From: Jonas Lundqvist <jonas@gannon.se>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jonas Lundqvist <jonas@gannon.se>
Subject: [PATCH v2] Staging: line6: remove spaces before commas.
Date: Mon, 29 Dec 2014 22:12:00 +0100
Message-Id: <1419887520-8332-1-git-send-email-jonas@gannon.se>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix three space prohibited errors in pcm.h found by checkpatch.pl.

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

