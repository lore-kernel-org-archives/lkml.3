Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaAVTxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:53:10 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:35622
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046AbaAVTxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:53:08 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de, alan@linux.intel.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH] staging/usbip: Add missing speeds to userspace speed_strings array
Date: Wed, 22 Jan 2014 12:53:03 -0700
Message-Id: <1390420383-3933-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add speed strings for usb wireless and 3.0 to speed_strings array.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/staging/usbip/userspace/libsrc/usbip_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
index 66f03cc..8cb4fcc 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
@@ -23,6 +23,8 @@ static const struct speed_string speed_strings[] = {
 	{ USB_SPEED_LOW,  "1.5", "Low Speed(1.5Mbps)"  },
 	{ USB_SPEED_FULL, "12",  "Full Speed(12Mbps)" },
 	{ USB_SPEED_HIGH, "480", "High Speed(480Mbps)" },
+	{ USB_SPEED_WIRELESS, "2.5", "Wireless"},
+	{ USB_SPEED_SUPER, "5000", "Super Speed(5000Mbps)" },
 	{ 0, NULL, NULL }
 };
 
-- 
1.8.3.2

