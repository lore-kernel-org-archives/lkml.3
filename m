Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbaCDUEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:04:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbaCDUEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Manu Gupta <manugupt1@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3.13 135/172] staging: r8188eu: Add new device ID
Date: Tue,  4 Mar 2014 12:03:39 -0800
Message-Id: <20140304200304.030914489@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manu Gupta <manugupt1@gmail.com>

commit 260ea9c2e2d330303163e286ab01b66dbcfe3a6f upstream.

The D-Link DWA-123 REV D1 with USB ID 2001:3310 uses this driver.

Signed-off-by: Manu Gupta <manugupt1@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -55,6 +55,7 @@ static struct usb_device_id rtw_usb_id_t
 	/****** 8188EUS ********/
 	{USB_DEVICE(0x07b8, 0x8179)}, /* Abocom - Abocom */
 	{USB_DEVICE(0x2001, 0x330F)}, /* DLink DWA-125 REV D1 */
+	{USB_DEVICE(0x2001, 0x3310)}, /* Dlink DWA-123 REV D1 */
 	{}	/* Terminating entry */
 };
 


