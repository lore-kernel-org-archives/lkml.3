Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358AbaE2Ei6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:38:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933301AbaE2Ei4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        Antonella Pellizzari <anto.pellizzari83@gmail.com>,
        Dan Williams <dcbw@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 77/86] net: qmi_wwan: Olivetti Olicard 200 support
Date: Wed, 28 May 2014 21:37:52 -0700
Message-Id: <20140529043523.688867343@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
References: <20140529043513.451722422@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enrico Mioso <mrkiko.rs@gmail.com>

[ Upstream commit ce97fef4235378108ed3bd96e1b3eab8fd0a1fbd ]

This is a QMI device, manufactured by TCT Mobile Phones.
A companion patch blacklisting this device's QMI interface in the option.c
driver has been sent.

Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
Signed-off-by: Antonella Pellizzari <anto.pellizzari83@gmail.com>
Tested-by: Dan Williams <dcbw@redhat.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -716,6 +716,7 @@ static const struct usb_device_id produc
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1201, 2)},	/* Telit LE920 */
+	{QMI_FIXED_INTF(0x0b3c, 0xc005, 6)},    /* Olivetti Olicard 200 */
 	{QMI_FIXED_INTF(0x1e2d, 0x0060, 4)},	/* Cinterion PLxx */
 
 	/* 4. Gobi 1000 devices */


