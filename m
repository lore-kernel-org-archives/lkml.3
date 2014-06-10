Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981AbaFJUMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:12:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35355 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbaFJTv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:51:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Victor A. Santos" <victoraur.santos@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 150/160] USB: Nokia 305 should be treated as unusual dev
Date: Tue, 10 Jun 2014 12:46:30 -0700
Message-Id: <1402429600-20477-151-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Victor A. Santos" <victoraur.santos@gmail.com>

commit f0ef5d41792a46a1085dead9dfb0bdb2c574638e upstream.

Signed-off-by: Victor A. Santos <victoraur.santos@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index adbeb25..1010341 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -234,6 +234,13 @@ UNUSUAL_DEV(  0x0421, 0x0495, 0x0370, 0x0370,
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
-- 
1.9.1

