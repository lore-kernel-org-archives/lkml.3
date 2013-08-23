Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab3HWRe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:34:58 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:13077 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab3HWRe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:34:57 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 6/6] staging: ozwpan: change max. TX frame size supported.
Date: Fri, 23 Aug 2013 18:33:33 +0100
Message-ID: <1377279213-17074-6-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377279213-17074-1-git-send-email-rupesh.gujare@atmel.com>
References: <1377279213-17074-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max. TX frame size supported is changed to 760 bytes.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozproto.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
index e532347..0c49c8a 100644
--- a/drivers/staging/ozwpan/ozproto.h
+++ b/drivers/staging/ozwpan/ozproto.h
@@ -19,7 +19,7 @@
 #define OZ_PRESLEEP_TOUT	11
 
 /* Maximun sizes of tx frames. */
-#define OZ_MAX_TX_SIZE		1514
+#define OZ_MAX_TX_SIZE		760
 
 /* Maximum number of uncompleted isoc frames that can be pending in network. */
 #define OZ_MAX_SUBMITTED_ISOC	16
-- 
1.7.9.5

