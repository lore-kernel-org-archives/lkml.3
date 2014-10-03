Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbaJCWAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:00:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000AbaJCV7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:59:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 3.14 074/238] USB: sisusb: add device id for Magic Control USB video
Date: Fri,  3 Oct 2014 14:29:49 -0700
Message-Id: <20141003212916.044681991@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Hemminger <stephen@networkplumber.org>

commit 5b6b80aeb21091ed3030b9b6aae597d81326f1aa upstream.

I have a j5 create (JUA210) USB 2 video device and adding it device id
to SIS USB video gets it to work.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/sisusbvga/sisusb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3248,6 +3248,7 @@ static const struct usb_device_id sisusb
 	{ USB_DEVICE(0x0711, 0x0918) },
 	{ USB_DEVICE(0x0711, 0x0920) },
 	{ USB_DEVICE(0x0711, 0x0950) },
+	{ USB_DEVICE(0x0711, 0x5200) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },
 	{ }


