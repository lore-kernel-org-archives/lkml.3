Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060Ab3CMSZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:25:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48514 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab3CMSZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:25:56 -0400
From: manoj.iyer@canonical.com
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Timo Aaltonen <tjaalton@ubuntu.com>, linux-usb@vger.kernel.org,
        manoj.iyer@canonical.com
Subject: [PATCH 1/1] USB: Added quirk to recognize GE0301 3G modem as an interface.
Date: Wed, 13 Mar 2013 13:25:52 -0500
Message-Id: <1363199152-7113-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363199082-7081-1-git-send-email-manoj.iyer@canonical.com>
References: <1363199082-7081-1-git-send-email-manoj.iyer@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manoj Iyer <manoj.iyer@canonical.com>

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
Reported-by: Timo Aaltonen <tjaalton@ubuntu.com>
Original-author: Timo Aaltonen <tjaalton@ubuntu.com>

BugLink: http://bugs.launchpad.net/bugs/348861
---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 72923b5..f31a6f9 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1169,6 +1169,13 @@ UNUSUAL_DEV(  0x0af0, 0x6971, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, option_ms_init,
 		0),
 
+/* Reported by Timo Aaltonen <tjaalton@ubuntu.com> */
+UNUSUAL_DEV( 0x0af0, 0x7011, 0x0000, 0x9999,
+		"Option",
+		"Mass Storage",
+		USB_SC_DEVICE, USB_PR_DEVICE, option_ms_init,
+		0 ),
+
 /* Reported by F. Aben <f.aben@option.com>
  * This device (wrongly) has a vendor-specific device descriptor.
  * The entry is needed so usb-storage can bind to it's mass-storage
-- 
1.7.9.5

