Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaCRNjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:39:06 -0400
Received: from zproxy110.enst.fr ([137.194.52.33]:37614 "EHLO
	zproxy110.enst.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbaCRNjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:39:04 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Mar 2014 09:39:04 EDT
From: ileana@telecom-paristech.fr
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        hans.verkuil@cisco.com, peter.p.waskiewicz.jr@intel.com,
        uma.sharma523@gmail.com, m.chehab@samsung.com,
        Ioana Ileana <ileana@enst.fr>
Subject: [PATCH] staging: omap24xx: fix coding style
Date: Tue, 18 Mar 2014 14:31:03 +0100
Message-Id: <1395149463-362-1-git-send-email-ileana@telecom-paristech.fr>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix missing parentheses in macros
Errors found by checkpatch.pl

Signed-off-by: Ioana Ileana <ileana@enst.fr>
---
 drivers/staging/media/omap24xx/tcm825x.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/omap24xx/tcm825x.h b/drivers/staging/media/omap24xx/tcm825x.h
index e2d1bcd..bfb72ee 100644
--- a/drivers/staging/media/omap24xx/tcm825x.h
+++ b/drivers/staging/media/omap24xx/tcm825x.h
@@ -21,8 +21,8 @@
 
 #define TCM825X_NAME "tcm825x"
 
-#define TCM825X_MASK(x)  x & 0x00ff
-#define TCM825X_ADDR(x) (x & 0xff00) >> 8
+#define TCM825X_MASK(x) (x & 0x00ff)
+#define TCM825X_ADDR(x) ((x & 0xff00) >> 8)
 
 /* The TCM825X I2C sensor chip has a fixed slave address of 0x3d. */
 #define TCM825X_I2C_ADDR	0x3d
-- 
1.7.9.5

