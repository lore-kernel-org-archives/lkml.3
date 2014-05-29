Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbaE2OVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:21:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59311 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933149AbaE2Nta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Raymond Wanyoike <raymond.wanyoike@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 014/103] net: qmi_wwan: add ZTE MF667
Date: Thu, 29 May 2014 15:47:59 +0200
Message-Id: <341bc61c767602bd9f696094d047702e1fbcc26a.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raymond Wanyoike <raymond.wanyoike@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7653aabfbdc73c1567e29a9790701f5898ba1420 upstream.

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index caaaf128f16c..18dcafd64ff4 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -699,6 +699,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x19d2, 0x1255, 3)},
 	{QMI_FIXED_INTF(0x19d2, 0x1255, 4)},
 	{QMI_FIXED_INTF(0x19d2, 0x1256, 4)},
+	{QMI_FIXED_INTF(0x19d2, 0x1270, 5)},	/* ZTE MF667 */
 	{QMI_FIXED_INTF(0x19d2, 0x1401, 2)},
 	{QMI_FIXED_INTF(0x19d2, 0x1402, 2)},	/* ZTE MF60 */
 	{QMI_FIXED_INTF(0x19d2, 0x1424, 2)},
-- 
1.9.3

