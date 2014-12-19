Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaLSJWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:22:12 -0500
Received: from mailrelay1.public.one.com ([91.198.169.124]:40406 "EHLO
	mailrelay1.public.one.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaLSJWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:22:10 -0500
X-Greylist: delayed 964 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Dec 2014 04:22:10 EST
X-HalOne-Cookie: db03e8467d50c5ec493bc617531123561856f1fb
X-HalOne-ID: 412bf987-875e-11e4-ba3a-b8ca3afa9d73
From: Henrik Rydberg <rydberg@bitmath.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@bitmath.org>
Subject: [PATCH] MAINTAINERS: Update rydberg's addresses
Date: Fri, 19 Dec 2014 10:06:07 +0100
Message-Id: <1418979967-2134-1-git-send-email-rydberg@bitmath.org>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My ISP finally gave up on the old mail address, so I am moving things
over to bitmath.org instead. Also change the status fields to better
reflect reality.

Signed-off-by: Henrik Rydberg <rydberg@bitmath.org>
---
 MAINTAINERS | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c721042..62b53e8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -714,15 +714,15 @@ F:	include/uapi/linux/apm_bios.h
 F:	drivers/char/apm-emulation.c
 
 APPLE BCM5974 MULTITOUCH DRIVER
-M:	Henrik Rydberg <rydberg@euromail.se>
+M:	Henrik Rydberg <rydberg@bitmath.org>
 L:	linux-input@vger.kernel.org
-S:	Maintained
+S:	Odd fixes
 F:	drivers/input/mouse/bcm5974.c
 
 APPLE SMC DRIVER
-M:	Henrik Rydberg <rydberg@euromail.se>
+M:	Henrik Rydberg <rydberg@bitmath.org>
 L:	lm-sensors@lm-sensors.org
-S:	Maintained
+S:	Odd fixes
 F:	drivers/hwmon/applesmc.c
 
 APPLETALK NETWORK LAYER
@@ -4813,10 +4813,10 @@ F:	include/uapi/linux/input.h
 F:	include/linux/input/
 
 INPUT MULTITOUCH (MT) PROTOCOL
-M:	Henrik Rydberg <rydberg@euromail.se>
+M:	Henrik Rydberg <rydberg@bitmath.org>
 L:	linux-input@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git
-S:	Maintained
+S:	Odd fixes
 F:	Documentation/input/multi-touch-protocol.txt
 F:	drivers/input/input-mt.c
 K:	\b(ABS|SYN)_MT_
-- 
2.1.3

