Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaFEFJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:09:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaFEEUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Victor A. Santos" <victoraur.santos@gmail.com>
Subject: [PATCH 3.4 054/214] USB: Nokia 305 should be treated as unusual dev
Date: Wed,  4 Jun 2014 21:16:57 -0700
Message-Id: <20140605041646.715432609@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Victor A. Santos" <victoraur.santos@gmail.com>

commit f0ef5d41792a46a1085dead9dfb0bdb2c574638e upstream.

Signed-off-by: Victor A. Santos <victoraur.santos@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -226,6 +226,13 @@ UNUSUAL_DEV(  0x0421, 0x0495, 0x0370, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_MAX_SECTORS_64 ),
 
+/* Patch submitted by Victor A. Santos <victoraur.santos@gmail.com> */
+UNUSUAL_DEV(  0x0421, 0x05af, 0x0742, 0x0742,
+		"Nokia",
+		"305",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64),
+
 /* Patch submitted by Mikhail Zolotaryov <lebon@lebon.org.ua> */
 UNUSUAL_DEV(  0x0421, 0x06aa, 0x1110, 0x1110,
 		"Nokia",


