Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab3KJOXC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 09:23:02 -0500
Received: from trinity.catbull.com ([88.198.52.214]:55016 "EHLO catbull.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab3KJOXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 09:23:00 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Nov 2013 09:23:00 EST
From: Joachim Adolf Schuetz <jas@catbull.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joachim Adi Schuetz <jas@catbull.com>
Subject: [PATCH] staging: ced401: ced_ioc: fix a blank/tab codingstyle issue.
Date: Sun, 10 Nov 2013 15:15:06 +0100
Message-Id: <1384092906-23100-1-git-send-email-jas@catbull.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joachim Adi Schuetz <jas@catbull.com>

Fixed a coding style issue - removed a blank before a tab.

Signed-off-by: Joachim Adolf Schuetz <jas@catbull.com>
---
 drivers/staging/ced1401/ced_ioc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.2.5

