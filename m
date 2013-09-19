Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab3ISOMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:12:47 -0400
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:48919 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752900Ab3ISOM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:12:26 -0400
X-RRZE-Submit-IP: 131.188.42.159
From: Dominik Paulus <dominik.paulus@fau.de>
To: usbip-devel@lists.sourceforge.net
Cc: Dominik Paulus <dominik.paulus@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        Stefan Reif <ke42caxa@cip.cs.fau.de>, Joe Perches <joe@perches.com>,
        Bart Westgeest <bart@elbrys.com>,
        Jake Champlin <jake.champlin.27@gmail.com>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Bernard Blackham <b-linuxgit@largestprime.net>,
        Harvey Yang <harvey.huawei.yang@gmail.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@i4.cs.fau.de,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] staging: usbip: Increment version number to 1.2.1
Date: Thu, 19 Sep 2013 16:11:59 +0200
Message-Id: <1379599919-24763-8-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379599919-24763-1-git-send-email-dominik.paulus@fau.de>
References: <1379599919-24763-1-git-send-email-dominik.paulus@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also increment the kernel module version number to match the
userspace version, as compatibility with old userspace utilities
is now at least partially broken.

Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/staging/usbip/usbip_common.h         | 2 +-
 drivers/staging/usbip/userspace/configure.ac | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
index 2b71c58..82a3e12 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -31,7 +31,7 @@
 #include <linux/wait.h>
 #include <linux/kfifo.h>
 
-#define USBIP_VERSION "1.0.0"
+#define USBIP_VERSION "1.2.1"
 
 /*
  * Length of the authentication tag associated with each packet, in bytes. Can
diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index a1a1267..26dabe3 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.59)
-AC_INIT([usbip-utils], [1.2.0], [linux-usb@vger.kernel.org])
+AC_INIT([usbip-utils], [1.2.1], [linux-usb@vger.kernel.org])
 
 CURRENT=0
 REVISION=1
-- 
1.8.4

