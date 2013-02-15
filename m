Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3BOUNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:13:07 -0500
Received: from mout.gmx.net ([212.227.15.18]:51456 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab3BOUNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:13:05 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/67tlUhQ/6GjmxNvABSuTD0iJZDWLR+fKFDro5C9
	rgtGxv3hAmvx0a
From: Peter Huewe <peterhuewe@gmx.de>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 3/4] staging/ozwpan: Remove empty and unused function oz_cdev_heartbeat
Date: Fri, 15 Feb 2013 21:17:23 +0100
Message-Id: <1360959444-5961-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360959444-5961-1-git-send-email-peterhuewe@gmx.de>
References: <1360959444-5961-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oz_cdev_heartbeat is empty and unused -> safe to remove.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/ozwpan/ozcdev.c |    6 ------
 drivers/staging/ozwpan/ozcdev.h |    1 -
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 04e0054..89d454e 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -525,9 +525,3 @@ void oz_cdev_rx(struct oz_pd *pd, struct oz_elt *elt)
 out:
 	oz_cdev_release_ctx(ctx);
 }
-/*------------------------------------------------------------------------------
- * Context: softirq
- */
-void oz_cdev_heartbeat(struct oz_pd *pd)
-{
-}
diff --git a/drivers/staging/ozwpan/ozcdev.h b/drivers/staging/ozwpan/ozcdev.h
index 698014b..dd11935 100644
--- a/drivers/staging/ozwpan/ozcdev.h
+++ b/drivers/staging/ozwpan/ozcdev.h
@@ -13,6 +13,5 @@ void oz_cdev_term(void);
 int oz_cdev_start(struct oz_pd *pd, int resume);
 void oz_cdev_stop(struct oz_pd *pd, int pause);
 void oz_cdev_rx(struct oz_pd *pd, struct oz_elt *elt);
-void oz_cdev_heartbeat(struct oz_pd *pd);
 
 #endif /* _OZCDEV_H */
-- 
1.7.8.6

