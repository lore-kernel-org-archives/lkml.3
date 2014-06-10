Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346AbaFJUYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:24:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35170 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbaFJTu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:50:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 093/160] usb: qcserial: add Sierra Wireless MC73xx
Date: Tue, 10 Jun 2014 12:45:33 -0700
Message-Id: <1402429600-20477-94-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit 70a3615fc07c2330ed7c1e922f3c44f4a67c0762 upstream.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/qcserial.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 6622352..1d1bc9b 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -136,6 +136,9 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68a2, 0)},	/* Sierra Wireless MC7710 Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68a2, 2)},	/* Sierra Wireless MC7710 NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68a2, 3)},	/* Sierra Wireless MC7710 Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68c0, 0)},	/* Sierra Wireless MC73xx Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68c0, 2)},	/* Sierra Wireless MC73xx NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x68c0, 3)},	/* Sierra Wireless MC73xx Modem */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 0)},	/* Sierra Wireless EM7700 Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 2)},	/* Sierra Wireless EM7700 NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x901c, 3)},	/* Sierra Wireless EM7700 Modem */
-- 
1.9.1

