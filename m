Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3KBRZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 13:25:51 -0400
Received: from mout.gmx.net ([212.227.15.19]:59154 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab3KBRZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 13:25:18 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: james.l.morris@oracle.com, tpmdd-devel@lists.sourceforge.net,
        adlai@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Peter Huewe <PeterHuewe@gmx.de>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 6/6] tpm: MAINTAINERS: Cleanup TPM Maintainers file
Date: Sat,  2 Nov 2013 18:25:01 +0100
Message-Id: <1383413101-10975-6-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1383413101-10975-1-git-send-email-peterhuewe@gmx.de>
References: <trinity-0ea948ed-45da-4711-91da-0d251d630d89-1383412993117@3capp-gmx-bs02>
 <1383413101-10975-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:izITKwX5JUoIcdcI64GP1cauNBZA7iIZmLNvTUUEvC1nWJfcjNn
 YMRXtwZdGA2tWvj1bTv1E376ZjkMDJD2BbqgSm5J8mODF3xkKtGBVJEkW95rQH8xARJGf9m
 +ZcAJPeYO4fpiJx1b6uhXEgb/CE9m5GjWscLCb4e83rXqRDiuShZFAsLnMZQw1wEls8ZgIK
 ByoVd0E5+psFi4A8bUKWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <PeterHuewe@gmx.de>

- removing stale/inactive maintainers
- removing stale/outdated website
- regrouped maintainers

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 MAINTAINERS |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 936adb4..0f42b97 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8473,14 +8473,10 @@ S:	Odd fixes
 F:	drivers/media/usb/tm6000/
 
 TPM DEVICE DRIVER
-M:	Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
-M:	Ashley Lai <ashley@ashleylai.com>
 M:	Peter Huewe <peterhuewe@gmx.de>
-M:	Rajiv Andrade <mail@srajiv.net>
-W:	http://tpmdd.sourceforge.net
+M:	Ashley Lai <ashley@ashleylai.com>
 M:	Marcel Selhorst <tpmdd@selhorst.net>
-M:	Sirrix AG <tpmdd@sirrix.com>
-W:	http://www.sirrix.com
+W:	http://tpmdd.sourceforge.net
 L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/char/tpm/
-- 
1.7.5.4

