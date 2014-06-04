Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaFDXWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:22:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaFDXWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniele Forsi <dforsi@gmail.com>
Subject: [PATCH 3.14 092/228] USB: Nokia 5300 should be treated as unusual dev
Date: Wed,  4 Jun 2014 16:22:01 -0700
Message-Id: <20140604232351.002290718@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Forsi <dforsi@gmail.com>

commit 6ed07d45d09bc2aa60e27b845543db9972e22a38 upstream.

Signed-off-by: Daniele Forsi <dforsi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -234,6 +234,13 @@ UNUSUAL_DEV(  0x0421, 0x0495, 0x0370, 0x
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


