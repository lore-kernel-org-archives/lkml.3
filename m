Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaKAWje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:39:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60020 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750873AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <johan@kernel.org>,
        "=?UTF-8?q?Bj=C3=B8rn=20Mork?=" <bjorn@mork.no>,
        "Lars Melin" <larsm17@gmail.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.968829592@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 017/102] USB: sierra: add 1199:68AA device ID
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 5b3da69285c143b7ea76b3b9f73099ff1093ab73 upstream.

This VID:PID is used for some Direct IP devices behaving
identical to the already supported 0F3D:68AA devices.

Reported-by: Lars Melin <larsm17@gmail.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/sierra.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -300,6 +300,9 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x68A3, 0xFF, 0xFF, 0xFF),
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x68AA, 0xFF, 0xFF, 0xFF),
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
+	},
 	/* AT&T Direct IP LTE modems */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0F3D, 0x68AA, 0xFF, 0xFF, 0xFF),
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist

