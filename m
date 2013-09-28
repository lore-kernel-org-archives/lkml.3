Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab3I1RoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:44:07 -0400
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:43520 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754963Ab3I1Rnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:43:33 -0400
X-RRZE-Submit-IP: 212.255.254.196
From: Dominik Paulus <dominik.paulus@fau.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-kernel@i4.cs.fau.de,
        devel@driverdev.osuosl.org, tobias.polzer@fau.de,
        Dominik Paulus <dominik.paulus@fau.de>
Subject: [PATCHv3  16/16] staging: usbip: Increment version number to 1.2.1
Date: Sat, 28 Sep 2013 19:42:53 +0200
Message-Id: <1380390173-3746-16-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380390173-3746-1-git-send-email-dominik.paulus@fau.de>
References: <20130925233638.GA21396@kroah.com>
 <1380390173-3746-1-git-send-email-dominik.paulus@fau.de>
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
index 939a232..b315082 100644
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
1.8.4

