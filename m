Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbaHHVXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:23:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40891 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbaHHUus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:50:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 245/259] net: qmi_wwan: add two Sierra Wireless/Netgear devices
Date: Fri,  8 Aug 2014 13:41:08 -0700
Message-Id: <1407530482-4483-246-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

[ Upstream commit 5343330010a892b76a97fd93ad3c455a4a32a7fb ]

Add two device IDs found in an out-of-tree driver downloadable
from Netgear.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/qmi_wwan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index f415957..bfcd241 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -660,6 +660,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x05c6, 0x9084, 4)},
 	{QMI_FIXED_INTF(0x05c6, 0x920d, 0)},
 	{QMI_FIXED_INTF(0x05c6, 0x920d, 5)},
+	{QMI_FIXED_INTF(0x0846, 0x68a2, 8)},
 	{QMI_FIXED_INTF(0x12d1, 0x140c, 1)},	/* Huawei E173 */
 	{QMI_FIXED_INTF(0x12d1, 0x14ac, 1)},	/* Huawei E1820 */
 	{QMI_FIXED_INTF(0x16d8, 0x6003, 0)},	/* CMOTech 6003 */
@@ -746,6 +747,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1199, 0x901f, 8)},    /* Sierra Wireless EM7355 */
 	{QMI_FIXED_INTF(0x1199, 0x9041, 8)},	/* Sierra Wireless MC7305/MC7355 */
 	{QMI_FIXED_INTF(0x1199, 0x9051, 8)},	/* Netgear AirCard 340U */
+	{QMI_FIXED_INTF(0x1199, 0x9057, 8)},
 	{QMI_FIXED_INTF(0x1bbb, 0x011e, 4)},	/* Telekom Speedstick LTE II (Alcatel One Touch L100V LTE) */
 	{QMI_FIXED_INTF(0x1bbb, 0x0203, 2)},	/* Alcatel L800MA */
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
-- 
1.9.1

