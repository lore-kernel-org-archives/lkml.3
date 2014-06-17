Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078AbaFQQXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:23:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50775 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933898AbaFQQXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:23:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Raymond Wanyoike <raymond.wanyoike@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 084/121] net: qmi_wwan: add ZTE MF667
Date: Tue, 17 Jun 2014 09:17:42 -0700
Message-Id: <1403021899-16708-57-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 64ed9b2..0c60e02 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -560,6 +560,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x19d2, 0x1255, 3)},
 	{QMI_FIXED_INTF(0x19d2, 0x1255, 4)},
 	{QMI_FIXED_INTF(0x19d2, 0x1256, 4)},
+	{QMI_FIXED_INTF(0x19d2, 0x1270, 5)},	/* ZTE MF667 */
 	{QMI_FIXED_INTF(0x19d2, 0x1401, 2)},
 	{QMI_FIXED_INTF(0x19d2, 0x1402, 2)},	/* ZTE MF60 */
 	{QMI_FIXED_INTF(0x19d2, 0x1424, 2)},
-- 
1.9.1

