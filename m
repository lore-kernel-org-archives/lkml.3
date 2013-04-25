Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3DYHht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 03:37:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52838 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3DYHhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 03:37:48 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] uio/aec: specify correct license in MODULE_LICENSE
Date: Thu, 25 Apr 2013 09:37:42 +0200
Message-Id: <1366875462-7864-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file header declares the code to be covered by GPL v2 only, so use
explicit v2 for MODULE_LICENSE, too.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/uio/uio_aec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_aec.c b/drivers/uio/uio_aec.c
index 1548982..9fed75c 100644
--- a/drivers/uio/uio_aec.c
+++ b/drivers/uio/uio_aec.c
@@ -170,7 +170,7 @@ static void __exit aectc_exit(void)
 	pci_unregister_driver(&pci_driver);
 }
 
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 
 module_init(aectc_init);
 module_exit(aectc_exit);
-- 
1.8.2.rc2

