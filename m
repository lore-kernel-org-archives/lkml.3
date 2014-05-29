Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097AbaE2FO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:14:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631AbaE2Efj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Bj=F8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 093/140] net: qmi_wwan: add Sierra Wireless EM7355
Date: Wed, 28 May 2014 21:33:52 -0700
Message-Id: <20140529043101.507836384@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

[ Upstream commit b85f5deaf052340021d025e120a9858f084a1d79 ]

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -724,6 +724,7 @@ static const struct usb_device_id produc
 	{QMI_FIXED_INTF(0x1199, 0x68a2, 8)},	/* Sierra Wireless MC7710 in QMI mode */
 	{QMI_FIXED_INTF(0x1199, 0x68a2, 19)},	/* Sierra Wireless MC7710 in QMI mode */
 	{QMI_FIXED_INTF(0x1199, 0x901c, 8)},    /* Sierra Wireless EM7700 */
+	{QMI_FIXED_INTF(0x1199, 0x901f, 8)},    /* Sierra Wireless EM7355 */
 	{QMI_FIXED_INTF(0x1199, 0x9051, 8)},	/* Netgear AirCard 340U */
 	{QMI_FIXED_INTF(0x1bbb, 0x011e, 4)},	/* Telekom Speedstick LTE II (Alcatel One Touch L100V LTE) */
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */


