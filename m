Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaCDTdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:33:39 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39400 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaCDTdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:33:37 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        andy.grover@gmail.com, Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH] staging: usbip: userspace: add hwdata as optional dependency in README
Date: Tue,  4 Mar 2014 21:33:27 +0200
Message-Id: <1393961607-22221-1-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
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

