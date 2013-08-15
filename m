Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab3HOVRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 17:17:35 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:65206 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3HOVRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 17:17:34 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Rob Landley <rob@landley.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH] Documentation: document all g_serial module parameters
Date: Thu, 15 Aug 2013 17:17:26 -0400
Message-Id: <1376601446-16044-1-git-send-email-matt.porter@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a table explaining the module parameters that g_serial
digests.

Signed-off-by: Matt Porter <matt.porter@linaro.org>
---
 Documentation/usb/gadget_serial.txt |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/usb/gadget_serial.txt b/Documentation/usb/gadget_serial.txt
index 61e67f6..d5eb27b 100644
--- a/Documentation/usb/gadget_serial.txt
+++ b/Documentation/usb/gadget_serial.txt
@@ -125,6 +125,19 @@ controller driver.  This must be done each time you reboot the gadget
 side Linux system.  You can add this to the start up scripts, if
 desired.
 
+Additionally, there are several module parameters to change g_serial
+behavior:
+
+	Parameter	Default		Description
+	---------	-------		-----------
+	use_acm		1		CDC ACM device
+	use_obex	0		CDC OBEX device
+	n_ports		1		Ports to instantiate
+
+To load g_serial as two ACM ports do this:
+
+  modprobe g_serial n_ports=2
+
 Your system should use mdev (from busybox) or udev to make the
 device nodes.  After this gadget driver has been set up you should
 then see a /dev/ttyGS0 node:
-- 
1.7.9.5

