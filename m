Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966651AbaFQVuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:50:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54420 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966632AbaFQVuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:50:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 033/212] net: qmi_wwan: add a number of CMOTech devices
Date: Tue, 17 Jun 2014 14:42:07 -0700
Message-Id: <1403041506-13646-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

[ Upstream commit 41be7d90993b1502d445bfc59e58348c258ce66a ]

A number of older CMOTech modems are based on Qualcomm
chips and exporting a QMI/wwan function.

Reported-by: Lars Melin <larsm17@gmail.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/qmi_wwan.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index b4fa268..c1dc9ce 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -662,6 +662,22 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x05c6, 0x920d, 5)},
 	{QMI_FIXED_INTF(0x12d1, 0x140c, 1)},	/* Huawei E173 */
 	{QMI_FIXED_INTF(0x12d1, 0x14ac, 1)},	/* Huawei E1820 */
+	{QMI_FIXED_INTF(0x16d8, 0x6003, 0)},	/* CMOTech 6003 */
+	{QMI_FIXED_INTF(0x16d8, 0x6007, 0)},	/* CMOTech CHE-628S */
+	{QMI_FIXED_INTF(0x16d8, 0x6008, 0)},	/* CMOTech CMU-301 */
+	{QMI_FIXED_INTF(0x16d8, 0x6280, 0)},	/* CMOTech CHU-628 */
+	{QMI_FIXED_INTF(0x16d8, 0x7001, 0)},	/* CMOTech CHU-720S */
+	{QMI_FIXED_INTF(0x16d8, 0x7002, 0)},	/* CMOTech 7002 */
+	{QMI_FIXED_INTF(0x16d8, 0x7003, 4)},	/* CMOTech CHU-629K */
+	{QMI_FIXED_INTF(0x16d8, 0x7004, 3)},	/* CMOTech 7004 */
+	{QMI_FIXED_INTF(0x16d8, 0x7006, 5)},	/* CMOTech CGU-629 */
+	{QMI_FIXED_INTF(0x16d8, 0x700a, 4)},	/* CMOTech CHU-629S */
+	{QMI_FIXED_INTF(0x16d8, 0x7211, 0)},	/* CMOTech CHU-720I */
+	{QMI_FIXED_INTF(0x16d8, 0x7212, 0)},	/* CMOTech 7212 */
+	{QMI_FIXED_INTF(0x16d8, 0x7213, 0)},	/* CMOTech 7213 */
+	{QMI_FIXED_INTF(0x16d8, 0x7251, 1)},	/* CMOTech 7251 */
+	{QMI_FIXED_INTF(0x16d8, 0x7252, 1)},	/* CMOTech 7252 */
+	{QMI_FIXED_INTF(0x16d8, 0x7253, 1)},	/* CMOTech 7253 */
 	{QMI_FIXED_INTF(0x19d2, 0x0002, 1)},
 	{QMI_FIXED_INTF(0x19d2, 0x0012, 1)},
 	{QMI_FIXED_INTF(0x19d2, 0x0017, 3)},
-- 
1.9.1

