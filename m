Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaCHM4K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 07:56:10 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:55984 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaCHMyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 07:54:15 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        andy.grover@gmail.com, Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 12/18] staging: usbip: userspace: update dependencies in README
Date: Sat,  8 Mar 2014 14:53:30 +0200
Message-Id: <1394283216-1277-13-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1394283216-1277-1-git-send-email-valentina.manea.m@gmail.com>
References: <1394283216-1277-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add libudev as dependency and remove libsysfs.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/userspace/README | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/userspace/README b/drivers/staging/usbip/userspace/README
index 00a1658..6ead290 100644
--- a/drivers/staging/usbip/userspace/README
+++ b/drivers/staging/usbip/userspace/README
@@ -9,8 +9,8 @@
     - USB/IP device drivers
 	Found in the staging directory of the Linux kernel.
 
-    - sysfsutils >= 2.0.0
-	sysfsutils library
+    - libudev >= 2.0
+	libudev library
 
     - libwrap0-dev
 	tcp wrapper library
-- 
1.8.1.2

