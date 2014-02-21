Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbaBUNjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:39:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47056 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353AbaBUMuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 067/121] usb: qcserial: add Netgear Aircard 340U
Date: Fri, 21 Feb 2014 12:48:11 +0000
Message-Id: <1392986945-9693-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit f948dcf9e9973c05d957bc65b3185682f45feda3 upstream.

This device was mentioned in an OpenWRT forum.  Seems to have a "standard"
Sierra Wireless ifnumber to function layout:
 0: qcdm
 2: nmea
 3: modem
 8: qmi
 9: storage

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/qcserial.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index c65437c..968a402 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -139,6 +139,9 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 0)},	/* Sierra Wireless EM7700 Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 2)},	/* Sierra Wireless EM7700 NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 3)},	/* Sierra Wireless EM7700 Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 0)},	/* Netgear AirCard 340U Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 2)},	/* Netgear AirCard 340U NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 3)},	/* Netgear AirCard 340U Modem */
 
 	{ }				/* Terminating entry */
 };
-- 
1.9.0

