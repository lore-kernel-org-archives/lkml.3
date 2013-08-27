Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3H0PyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:54:00 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:27762 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3H0Px7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:53:59 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 1/4] staging: ozwpan: Increase ISOC IN buffer depth
Date: Tue, 27 Aug 2013 16:53:40 +0100
Message-ID: <1377618823-12246-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase ISOC IN buffer depth to 100 units.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 3548860..b0398c5 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -39,7 +39,7 @@
  * Number of units of buffering to capture for an isochronous IN endpoint before
  * allowing data to be indicated up.
  */
-#define OZ_IN_BUFFERING_UNITS	50
+#define OZ_IN_BUFFERING_UNITS	100
 
 /* Name of our platform device.
  */
-- 
1.7.9.5

