Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965627AbaFQQsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:48:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50746 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965022AbaFQQXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:23:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Enrico Mioso <mrkiko.rs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 080/121] qmi_wwan: add ONDA MT689DC device ID (fwd)
Date: Tue, 17 Jun 2014 09:17:38 -0700
Message-Id: <1403021899-16708-53-git-send-email-kamal@canonical.com>
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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index e16f7c8..a360af0 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -514,6 +514,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x19d2, 0x0002, 1)},
 	{QMI_FIXED_INTF(0x19d2, 0x0012, 1)},
 	{QMI_FIXED_INTF(0x19d2, 0x0017, 3)},
+	{QMI_FIXED_INTF(0x19d2, 0x0019, 3)},	/* ONDA MT689DC */
 	{QMI_FIXED_INTF(0x19d2, 0x0021, 4)},
 	{QMI_FIXED_INTF(0x19d2, 0x0025, 1)},
 	{QMI_FIXED_INTF(0x19d2, 0x0031, 4)},
-- 
1.9.1

