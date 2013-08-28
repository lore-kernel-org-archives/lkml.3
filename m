Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab3H1Lnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:43:47 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:57450 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3H1Lnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:43:46 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <sergei.shtylyov@cogentembedded.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [v2 PATCH 1/3] staging: ozwpan: Increase ISOC IN buffer depth
Date: Wed, 28 Aug 2013 12:43:14 +0100
Message-ID: <1377690196-4516-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buffer depth of 50 units is not sufficient when there is considerable delay
occuring on air due to interference, increase ISOC IN buffer depth to 100 units.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index d6c3d0e..d9c43c3 100644
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

