Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaK3KYo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 05:24:44 -0500
Received: from smtp2-out.insa-rennes.fr ([193.52.94.25]:46566 "EHLO
	smtp2-out.insa-rennes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaK3KYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 05:24:42 -0500
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Nov 2014 05:24:42 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqMEAAPtelQKBQEm/2dsb2JhbABb0X2BIAEBAQEBfYUCPDQCTAEMAQcBAdpwAQEBAQEFAQEBAR6QGgpXhE8FnXWDO4JpN4k4h34lgU6BQgEBAQ
Message-ID: <547AEE16.20603@supelec.fr>
Date: Sun, 30 Nov 2014 11:14:46 +0100
From: Laurent Georget <laurent.georget@supelec.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        linux-man <linux-man@vger.kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2 v3] adjtimex.2: add fields in struct timex description
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this is a refactored series of patches for adjtimex(2) man page. Please
ignore all previous patches I sent for adjtimex.2.

The first patch updates the man page with the new fields added in struct
timex since last edition of the man page.

Thank you for your time. These are my first patches so you may have to
bear with me being a little inexpert and clumsy for some time. I
apologize for that.

Laurent

diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
index eb3fda1..0b919c5 100644
--- a/man2/adjtimex.2
+++ b/man2/adjtimex.2
@@ -73,6 +73,15 @@ struct timex {
                             (read-only) */
     struct timeval time; /* current time (read-only) */
     long tick;           /* usecs between clock ticks */
+    long ppsfreq;        /* pps frequency (scaled ppm) (read-only) */
+    long jitter;         /* pps jitter (usec) (read-only) */
+    int shift;           /* interval duration (sec) (read-only) */
+    long stabil;         /* pps stability (scaled ppm) (read-only) */
+    long jitcnt;         /* jitter limit exceeded (read-only) */
+    long calcnt;         /* calibration intervals (read-only) */
+    long errcnt;         /* calibration errors (read-only) */
+    long stbcnt;         /* stability limit exceeded (read-only) */
+    int tai;             /* TAI offset (s) (read-only) */
 };
 .fi
 .in
