Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaFGBhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:37:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36037 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615AbaFGBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniele Forsi" <dforsi@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.477580928@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 49/92] USB: Nokia 5300 should be treated as unusual dev
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Forsi <dforsi@gmail.com>

commit 6ed07d45d09bc2aa60e27b845543db9972e22a38 upstream.

Signed-off-by: Daniele Forsi <dforsi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -226,6 +226,13 @@ UNUSUAL_DEV(  0x0421, 0x0495, 0x0370, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_MAX_SECTORS_64 ),
 
+/* Reported by Daniele Forsi <dforsi@gmail.com> */
+UNUSUAL_DEV(  0x0421, 0x04b9, 0x0350, 0x0350,
+		"Nokia",
+		"5300",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64 ),
+
 /* Patch submitted by Victor A. Santos <victoraur.santos@gmail.com> */
 UNUSUAL_DEV(  0x0421, 0x05af, 0x0742, 0x0742,
 		"Nokia",

