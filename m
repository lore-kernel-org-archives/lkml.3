Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3JSOjz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 10:39:55 -0400
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:56290 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169Ab3JSOja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org,>);
	Sat, 19 Oct 2013 10:39:30 -0400
X-RRZE-Submit-IP: 212.255.122.85
From: Dominik Paulus <dominik.paulus@fau.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dominik Paulus <dominik.paulus@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de, Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        linux-kernel@vger.kernel.org, tobias.polzer@fau.de,
        Ilija Hadzic <ihadzic@research.bell-labs.com>
Subject: [PATCHv4 16/16] staging: usbip: Increment version number to 1.2.1
Date: Sat, 19 Oct 2013 16:39:19 +0200
Message-Id: <1382193559-12549-17-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382193559-12549-1-git-send-email-dominik.paulus@fau.de>
References: <20130930123821.GI6192@mwanda>
 <1382193559-12549-1-git-send-email-dominik.paulus@fau.de>
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
index 8e2855e..3d40b86 100644
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
index bc08b81..26dabe3 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -1,7 +1,7 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.59)
-AC_INIT([usbip-utils], [1.1.1], [linux-usb@vger.kernel.org])
+AC_INIT([usbip-utils], [1.2.1], [linux-usb@vger.kernel.org])
 
 CURRENT=0
 REVISION=1
-- 
1.8.4.1

