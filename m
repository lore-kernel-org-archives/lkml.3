Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab3LESjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:39:40 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34733 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058Ab3LESji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:39:38 -0500
Date: Thu, 5 Dec 2013 10:38:19 -0800
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Chen Liqin <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        Glauber Costa <glommer@parallels.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH] doc: no singing
Message-ID: <20131205183819.GA2217@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop that, stop that! You're not going to do a song while I'm here.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
https://lkml.org/lkml/2013/12/4/786
http://www.youtube.com/watch?v=g3YiPC91QUk#t=62
---
 Documentation/cgroups/resource_counter.txt |    2 +-
 Documentation/video4linux/si476x.txt       |    2 +-
 arch/score/lib/checksum.S                  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/cgroups/resource_counter.txt b/Documentation/cgroups/resource_counter.txt
index c4d99ed0b418..caa6d662b230 100644
--- a/Documentation/cgroups/resource_counter.txt
+++ b/Documentation/cgroups/resource_counter.txt
@@ -95,7 +95,7 @@ to work with it.
 
  f. u64 res_counter_uncharge_until
 		(struct res_counter *rc, struct res_counter *top,
-		 unsinged long val)
+		 unsigned long val)
 
 	Almost same as res_cunter_uncharge() but propagation of uncharge
 	stops when rc == top. This is useful when kill a res_coutner in
diff --git a/Documentation/video4linux/si476x.txt b/Documentation/video4linux/si476x.txt
index 2f9b4875ab8a..616607955aaf 100644
--- a/Documentation/video4linux/si476x.txt
+++ b/Documentation/video4linux/si476x.txt
@@ -147,7 +147,7 @@ The drivers exposes following files:
   --------------------------------------------------------------------
   0x12		| readfreq	| Current tuned frequency
   --------------------------------------------------------------------
-  0x14		| freqoff	| Singed frequency offset in units of
+  0x14		| freqoff	| Signed frequency offset in units of
   		| 		| 2ppm
   --------------------------------------------------------------------
   0x15		| rssi		| Signed value of RSSI in dBuV
diff --git a/arch/score/lib/checksum.S b/arch/score/lib/checksum.S
index 706157edc7d5..1141f2b4a501 100644
--- a/arch/score/lib/checksum.S
+++ b/arch/score/lib/checksum.S
@@ -137,7 +137,7 @@ ENTRY(csum_partial)
 	ldi r25, 0
 	mv r10, r5
 	cmpi.c	r5, 0x8
-	blt	small_csumcpy		/* < 8(singed) bytes to copy */
+	blt	small_csumcpy		/* < 8(signed) bytes to copy */
 	cmpi.c	r5, 0x0
 	beq	out
 	andri.c	r25, src, 0x1		/* odd buffer? */
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
