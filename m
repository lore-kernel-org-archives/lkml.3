Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaLEXYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:24:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaLEW4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3.14 33/73] staging: r8188eu: Add new device ID for DLink GO-USB-N150
Date: Fri,  5 Dec 2014 14:44:39 -0800
Message-Id: <20141205224434.933455037@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 6d4556fc0309608f760f1d329df56d77fdd0c31a upstream.

The DLink GO-USB-N150 with revision B1 uses this driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -57,6 +57,7 @@ static struct usb_device_id rtw_usb_id_t
 	{USB_DEVICE(0x07b8, 0x8179)}, /* Abocom - Abocom */
 	{USB_DEVICE(0x2001, 0x330F)}, /* DLink DWA-125 REV D1 */
 	{USB_DEVICE(0x2001, 0x3310)}, /* Dlink DWA-123 REV D1 */
+	{USB_DEVICE(0x2001, 0x3311)}, /* DLink GO-USB-N150 REV B1 */
 	{USB_DEVICE(0x0df6, 0x0076)}, /* Sitecom N150 v2 */
 	{}	/* Terminating entry */
 };


