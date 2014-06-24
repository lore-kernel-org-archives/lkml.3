Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaFXJd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 05:33:29 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:55671 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbaFXJd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 05:33:27 -0400
Message-ID: <1403602404.1960.7.camel@x220>
Subject: [PATCH] Documentation: sysfs-bus-usb: update power/persist
 description
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-api@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 24 Jun 2014 11:33:24 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2014 09:33:24.0655 (UTC) FILETIME=[5898FBF0:01CF8F8F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no power/persist file for hubs. And CONFIG_USB_PERSIST was
removed in v2.6.26. Update the description of power/persist accordingly.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
I don't know anything about USB-Persist. Could Greg and Alan please
check whether the new description does actually match reality?

 Documentation/ABI/stable/sysfs-bus-usb | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-bus-usb b/Documentation/ABI/stable/sysfs-bus-usb
index a6b685724740..a61d04b8fc78 100644
--- a/Documentation/ABI/stable/sysfs-bus-usb
+++ b/Documentation/ABI/stable/sysfs-bus-usb
@@ -3,13 +3,13 @@ Date:		May 2007
 KernelVersion:	2.6.23
 Contact:	Alan Stern <stern@rowland.harvard.edu>
 Description:
-		If CONFIG_USB_PERSIST is set, then each USB device directory
-		will contain a file named power/persist.  The file holds a
-		boolean value (0 or 1) indicating whether or not the
-		"USB-Persist" facility is enabled for the device.  Since the
-		facility is inherently dangerous, it is disabled by default
-		for all devices except hubs.  For more information, see
-		Documentation/usb/persist.txt.
+		USB device directories for all devices except hubs will contain
+		a file named power/persist.  The file holds a boolean value (0
+		or 1) indicating whether or not the "USB-Persist" facility is
+		enabled for the device.  Since the facility is inherently
+		dangerous, it is disabled by default.  For hubs this facility is
+		always enabled making the file pointless.  For more information,
+		see Documentation/usb/persist.txt.
 
 What:		/sys/bus/usb/devices/.../power/autosuspend
 Date:		March 2007
-- 
1.9.3

