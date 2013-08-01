Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab3HARpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:45:12 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:47778 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab3HARpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:45:10 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 5/6] staging: ozwpan: Increase farewell report size.
Date: Thu, 1 Aug 2013 18:45:01 +0100
Message-ID: <1375379102-18217-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Farewell report size can be bigger than one byte, increase array
size to accomodate maximum 32 bytes of farewell report.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozpd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozpd.h b/drivers/staging/ozwpan/ozpd.h
index a281753..57e98c8 100644
--- a/drivers/staging/ozwpan/ozpd.h
+++ b/drivers/staging/ozwpan/ozpd.h
@@ -48,7 +48,7 @@ struct oz_farewell {
 	struct list_head link;
 	u8 ep_num;
 	u8 index;
-	u8 report[1];
+	u8 report[32];
 	u8 len;
 };
 
-- 
1.7.9.5

