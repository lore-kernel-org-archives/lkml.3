Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbaFEE3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:29:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbaFEEWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 189/214] wireless: rt2x00: rt{2500,73}usb.c put back duplicate id
Date: Wed,  4 Jun 2014 21:19:12 -0700
Message-Id: <20140605041704.846522343@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

commit 8f35f787b75e9b6435ea37dabcae2d40dc72d31c upstream.

put back 0x050d,0x7050 to rt73usb, same usb_id for two chips:

K7SF5D7050A ver 2xxx is rt2500
K7SF5D7050B ver 3xxx is rt73

<http://en-us-support.belkin.com/app/answers/detail/a_id/297/kw/K7SF5D7050>

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c   |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1921,7 +1921,7 @@ static struct usb_device_id rt2500usb_de
 	{ USB_DEVICE(0x0b05, 0x1706) },
 	{ USB_DEVICE(0x0b05, 0x1707) },
 	/* Belkin */
-	{ USB_DEVICE(0x050d, 0x7050) },
+	{ USB_DEVICE(0x050d, 0x7050) },	/* FCC ID: K7SF5D7050A ver. 2.x */
 	{ USB_DEVICE(0x050d, 0x7051) },
 	/* Cisco Systems */
 	{ USB_DEVICE(0x13b1, 0x000d) },
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2422,6 +2422,7 @@ static struct usb_device_id rt73usb_devi
 	{ USB_DEVICE(0x0b05, 0x1723) },
 	{ USB_DEVICE(0x0b05, 0x1724) },
 	/* Belkin */
+	{ USB_DEVICE(0x050d, 0x7050) },	/* FCC ID: K7SF5D7050B ver. 3.x */
 	{ USB_DEVICE(0x050d, 0x705a) },
 	{ USB_DEVICE(0x050d, 0x905b) },
 	{ USB_DEVICE(0x050d, 0x905c) },


