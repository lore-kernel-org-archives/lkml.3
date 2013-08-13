Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab3HMRZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:25:14 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:52399 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758910Ab3HMRZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:25:09 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH 04/10] staging: ozwpan: Fix coding style.
Date: Tue, 13 Aug 2013 18:24:24 +0100
Message-ID: <1376414670-23257-5-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376414670-23257-1-git-send-email-rupesh.gujare@atmel.com>
References: <1376414670-23257-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put spaces around math operations.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 4b658d4..2be15f4 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -1957,9 +1957,9 @@ static int oz_hcd_hub_status_data(struct usb_hcd *hcd, char *buf)
 			oz_dbg(HUB, "Port %d changed\n", i);
 			ozhcd->ports[i].flags &= ~OZ_PORT_F_CHANGED;
 			if (i < 7)
-				buf[0] |= 1 << (i+1);
+				buf[0] |= 1 << (i + 1);
 			else
-				buf[1] |= 1 << (i-7);
+				buf[1] |= 1 << (i - 7);
 		}
 	}
 	spin_unlock_bh(&ozhcd->hcd_lock);
-- 
1.7.9.5

