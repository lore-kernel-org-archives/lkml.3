Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbaJCVkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:40:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaJCViW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:38:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.16 116/357] USB: zte_ev: remove duplicate Gobi PID
Date: Fri,  3 Oct 2014 14:28:22 -0700
Message-Id: <20141003212936.963632310@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 95be5739588c56a9327e477aa0ba3c81c5cf8631 upstream.

Remove dublicate Gobi PID 0x9008 which is already handled by the
qcserial driver since commit f05932c0caf4 ("USB: qcserial: Add extra
device IDs").

Fixes: 799ee9243d89 ("USB: serial: add zte_ev.c driver")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/zte_ev.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/serial/zte_ev.c
+++ b/drivers/usb/serial/zte_ev.c
@@ -275,7 +275,6 @@ static const struct usb_device_id id_tab
 	/* MG880 */
 	{ USB_DEVICE(0x19d2, 0xfffd) },
 	{ USB_DEVICE(0x05C6, 0x3197) },
-	{ USB_DEVICE(0x05C6, 0x9008) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);


