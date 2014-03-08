Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaCHMzX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 07:55:23 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:63716 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaCHMy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 07:54:27 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        andy.grover@gmail.com, Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 18/18] staging: usbip: userspace: add hwdata as optional dependency in README
Date: Sat,  8 Mar 2014 14:53:36 +0200
Message-Id: <1394283216-1277-19-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1394283216-1277-1-git-send-email-valentina.manea.m@gmail.com>
References: <1394283216-1277-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an optional dependency since USB/IP can fully work without
it. However, it is needed to display device information such as
vendor.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/userspace/README | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/usbip/userspace/README b/drivers/staging/usbip/userspace/README
index 6ead290..f528ba4 100644
--- a/drivers/staging/usbip/userspace/README
+++ b/drivers/staging/usbip/userspace/README
@@ -19,6 +19,10 @@
 
     - libtool, automake >= 1.9, autoconf >= 2.5.0, pkg-config
 
+[Optional]
+    - hwdata
+        Contains USB device identification data.
+
 
 [Install]
     0. Generate configuration scripts.
-- 
1.8.1.2

