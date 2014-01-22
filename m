Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaAVRRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:17:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:55899 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbaAVRRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:17:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,701,1384329600"; 
   d="scan'208";a="470814933"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [staging-next] ion: dummy driver:  use ARRAY_SIZE for nr of heaps
Date: Wed, 22 Jan 2014 19:15:55 +0200
Message-Id: <1390410955-11530-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use ARRAY_SIZE to count number of heaps in static array

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/android/ion/ion_dummy_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_dummy_driver.c b/drivers/staging/android/ion/ion_dummy_driver.c
index 55b2002..c1df26c 100644
--- a/drivers/staging/android/ion/ion_dummy_driver.c
+++ b/drivers/staging/android/ion/ion_dummy_driver.c
@@ -57,7 +57,7 @@ struct ion_platform_heap dummy_heaps[] = {
 };
 
 struct ion_platform_data dummy_ion_pdata = {
-	.nr = 4,
+	.nr = ARRAY_SIZE(dummy_heaps),
 	.heaps = dummy_heaps,
 };
 
-- 
1.8.4.2

