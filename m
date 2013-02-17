Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3BQXK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:10:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45600 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754682Ab3BQWzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:00 -0500
Message-Id: <20130217225002.740337341@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:10 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniele Palmas <dnlplm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 09/66] USB: qcserial: add Telit Gobi QDL device
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Palmas <dnlplm@gmail.com>

commit 78796ae17eacedcdcaaeb03ba73d2e532a4c8f83 upstream.

Add VID and PID for Telit Gobi QDL device

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/qcserial.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index aa148c2..2466254 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -53,6 +53,7 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_G1K(0x05c6, 0x9221)},	/* Generic Gobi QDL device */
 	{DEVICE_G1K(0x05c6, 0x9231)},	/* Generic Gobi QDL device */
 	{DEVICE_G1K(0x1f45, 0x0001)},	/* Unknown Gobi QDL device */
+	{DEVICE_G1K(0x1bc7, 0x900e)},	/* Telit Gobi QDL device */
 
 	/* Gobi 2000 devices */
 	{USB_DEVICE(0x1410, 0xa010)},	/* Novatel Gobi 2000 QDL device */


