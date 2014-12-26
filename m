Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbaLZLb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 06:31:29 -0500
Received: from mout.gmx.com ([74.208.4.200]:53103 "EHLO mout.gmx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbaLZLb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 06:31:27 -0500
From: Damon Swayn <damon.swayn@null.net>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Damon Swayn <damon.swayn@null.net>
Subject: [PATCH] Staging: line6: pcm: Corrected checkpatch notices in pcm.h
Date: Fri, 26 Dec 2014 22:30:06 +1100
Message-Id: <1419593406-18978-1-git-send-email-damon.swayn@null.net>
X-Mailer: git-send-email 2.1.0
X-Provags-ID: V03:K0:PgRKXVBBWERfYKizUkj4Ecig1g7uL5wwyb90EY1r+Ss1IG4W/rW
 tdYXBpLElB23rPXh/nPvU6vuufWftrf5NpnCTsm344/2u9fJFpzs7YM8jibBeJYCOYlyZL7
 iI28PZVZFbg8TkCSpzussMSLYCnyZNPdrWZAclqdKmjDa4UNMcP2Rs5LyaMNei+YfCSLi4n
 oijc3U1FNdqXC4ll+eh8A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue

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

