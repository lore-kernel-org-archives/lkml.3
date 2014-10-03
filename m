Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaJCW6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:58:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579AbaJCWYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.10 047/143] USB: zte_ev: remove duplicate Qualcom PID
Date: Fri,  3 Oct 2014 14:34:02 -0700
Message-Id: <20141003213315.893714720@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 754eb21c0bbbbc4b8830a9a864b286323b84225f upstream.

Remove dublicate Qualcom PID 0x3197 which is already handled by the
moto-modem driver since commit 6986a978eec7 ("USB: add new moto_modem
driver for some Morotola phones").

Fixes: 799ee9243d89 ("USB: serial: add zte_ev.c driver")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/zte_ev.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/serial/zte_ev.c
+++ b/drivers/usb/serial/zte_ev.c
@@ -275,7 +275,6 @@ static void zte_ev_usb_serial_close(stru
 static const struct usb_device_id id_table[] = {
 	/* MG880 */
 	{ USB_DEVICE(0x19d2, 0xfffd) },
-	{ USB_DEVICE(0x05C6, 0x3197) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);


