Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830AbaKLCnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:43:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834AbaKLBpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:45:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Cyril Brulebois <kibi@debian.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.14 143/203] wireless: rt2x00: add new rt2800usb device
Date: Wed, 12 Nov 2014 10:16:53 +0900
Message-Id: <20141112011549.264436521@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyril Brulebois <kibi@debian.org>

commit 664d6a792785cc677c2091038ce10322c8d04ae1 upstream.

0x1b75 0xa200 AirLive WN-200USB wireless 11b/g/n dongle

References: https://bugs.debian.org/766802
Reported-by: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Signed-off-by: Cyril Brulebois <kibi@debian.org>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1062,6 +1062,7 @@ static struct usb_device_id rt2800usb_de
 	/* Ovislink */
 	{ USB_DEVICE(0x1b75, 0x3071) },
 	{ USB_DEVICE(0x1b75, 0x3072) },
+	{ USB_DEVICE(0x1b75, 0xa200) },
 	/* Para */
 	{ USB_DEVICE(0x20b8, 0x8888) },
 	/* Pegatron */


