Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3HOLAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:00:40 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:62911 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab3HOLAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:00:38 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2] staging: ozwpan: Remove unneeded variable initializer
Date: Thu, 15 Aug 2013 12:00:21 +0100
Message-ID: <1376564422-8749-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are assigning value to hport before returning, there is
no need to initialize it.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 4cd08da..9a374fd 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -663,7 +663,7 @@ static inline void oz_hcd_put(struct oz_hcd *ozhcd)
 struct oz_port *oz_hcd_pd_arrived(void *hpd)
 {
 	int i;
-	struct oz_port *hport = NULL;
+	struct oz_port *hport;
 	struct oz_hcd *ozhcd;
 	struct oz_endpoint *ep;
 
-- 
1.7.9.5

