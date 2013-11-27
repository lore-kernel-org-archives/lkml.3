Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3K0KbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 05:31:00 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57622 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab3K0Ka6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 05:30:58 -0500
X-Originating-IP: 109.242.151.66
From: Aldo Iljazi <mail@aldo.io>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: ced1401: ced_ioc.c: Removed whitespace
Date: Wed, 27 Nov 2013 12:30:44 +0200
Message-Id: <1385548244-1491-1-git-send-email-mail@aldo.io>
X-Mailer: git-send-email 1.8.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line 633: Removed whitespace.

Signed-off-by: Aldo Iljazi <mail@aldo.io>
---
 drivers/staging/ced1401/ced_ioc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ced1401/ced_ioc.c b/drivers/staging/ced1401/ced_ioc.c
index 62efd74..043a932 100644
--- a/drivers/staging/ced1401/ced_ioc.c
+++ b/drivers/staging/ced1401/ced_ioc.c
@@ -630,7 +630,7 @@ int ClearArea(DEVICE_EXTENSION *pdx, int nArea)
 			}
 			spin_unlock_irq(&pdx->stagedLock);
 
-			if (pPages) { 	/*  if we decided to release the memory */
+			if (pPages) {	/*  if we decided to release the memory */
 				/*  Now we must undo the pinning down of the pages. We will assume the worst and mark */
 				/*  all the pages as dirty. Don't be tempted to move this up above as you must not be */
 				/*  holding a spin lock to do this stuff as it is not atomic. */
-- 
1.8.4.4

