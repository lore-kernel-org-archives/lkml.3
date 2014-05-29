Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395AbaE2Em4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:42:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933290AbaE2Eit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        =?UTF-8?q?Bj=F8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 74/86] qmi_wwan: add ONDA MT689DC device ID (fwd)
Date: Wed, 28 May 2014 21:37:49 -0700
Message-Id: <20140529043523.350724059@linuxfoundation.org>
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

From: Enrico Mioso <mrkiko.rs@gmail.com>

[ Upstream commit d8eb8f9963a55ccf6ebafa4bfdb9f70c17067825 ]

Another QMI-speaking device by ZTE, re-branded by ONDA!

I'm connected ovr this device's QMI interface right now, so I can say I tested
it! :)

Note: a follow-up patch was posted to the linux-usb mailing list, to prevent
the option driver from binding to the device's QMI interface, making it
unusable.

Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -652,6 +652,7 @@ static const struct usb_device_id produc
 	{QMI_FIXED_INTF(0x19d2, 0x0002, 1)},
 	{QMI_FIXED_INTF(0x19d2, 0x0012, 1)},
 	{QMI_FIXED_INTF(0x19d2, 0x0017, 3)},
+	{QMI_FIXED_INTF(0x19d2, 0x0019, 3)},	/* ONDA MT689DC */
 	{QMI_FIXED_INTF(0x19d2, 0x0021, 4)},
 	{QMI_FIXED_INTF(0x19d2, 0x0025, 1)},
 	{QMI_FIXED_INTF(0x19d2, 0x0031, 4)},


