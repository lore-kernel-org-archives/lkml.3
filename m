Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbaE2Eiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:38:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933301AbaE2Eiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Raymond Wanyoike <raymond.wanyoike@gmail.com>,
        =?UTF-8?q?Bj=F8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 78/86] net: qmi_wwan: add ZTE MF667
Date: Wed, 28 May 2014 21:37:53 -0700
Message-Id: <20140529043523.823445380@linuxfoundation.org>
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

From: Raymond Wanyoike <raymond.wanyoike@gmail.com>

[ Upstream commit 7653aabfbdc73c1567e29a9790701f5898ba1420 ]

The driver description files give these descriptions to the vendor specific
ports on this modem:

 VID_19D2&PID_1270&MI_00: "ZTE MF667 Diagnostics Port"
 VID_19D2&PID_1270&MI_01: "ZTE MF667 AT Port"
 VID_19D2&PID_1270&MI_02: "ZTE MF667 ATExt2 Port"
 VID_19D2&PID_1270&MI_03: "ZTE MF667 ATExt Port"
 VID_19D2&PID_1270&MI_04: "ZTE MF667 USB Modem"
 VID_19D2&PID_1270&MI_05: "ZTE MF667 Network Adapter"

Signed-off-by: Raymond Wanyoike <raymond.wanyoike@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -699,6 +699,7 @@ static const struct usb_device_id produc
 	{QMI_FIXED_INTF(0x19d2, 0x1255, 3)},
 	{QMI_FIXED_INTF(0x19d2, 0x1255, 4)},
 	{QMI_FIXED_INTF(0x19d2, 0x1256, 4)},
+	{QMI_FIXED_INTF(0x19d2, 0x1270, 5)},	/* ZTE MF667 */
 	{QMI_FIXED_INTF(0x19d2, 0x1401, 2)},
 	{QMI_FIXED_INTF(0x19d2, 0x1402, 2)},	/* ZTE MF60 */
 	{QMI_FIXED_INTF(0x19d2, 0x1424, 2)},


