Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802AbaE2E4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:56:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092AbaE2EiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH 3.10 29/86] usb: qcserial: add Sierra Wireless MC73xx
Date: Wed, 28 May 2014 21:37:04 -0700
Message-Id: <20140529043517.417728076@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
References: <20140529043513.451722422@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 70a3615fc07c2330ed7c1e922f3c44f4a67c0762 upstream.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/qcserial.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -136,6 +136,9 @@ static const struct usb_device_id id_tab
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68a2, 0)},	/* Sierra Wireless MC7710 Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68a2, 2)},	/* Sierra Wireless MC7710 NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68a2, 3)},	/* Sierra Wireless MC7710 Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68c0, 0)},	/* Sierra Wireless MC73xx Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68c0, 2)},	/* Sierra Wireless MC73xx NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68c0, 3)},	/* Sierra Wireless MC73xx Modem */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 0)},	/* Sierra Wireless EM7700 Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 2)},	/* Sierra Wireless EM7700 NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 3)},	/* Sierra Wireless EM7700 Modem */


