Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaAWJwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 04:52:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:31131 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbaAWJwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 04:52:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,705,1384329600"; 
   d="scan'208";a="463402305"
Subject: [PATCH] isci: update version to 1.2
To: JBottomley@Parallels.com
From: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Maciej Patelczyk <maciej.patelczyk@intel.com>
Date: Thu, 23 Jan 2014 10:52:01 +0100
Message-ID: <20140123095201.6396.47361.stgit@gklab-154-244.igk.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The version of isci driver has not been updated for 2 years.
It was 83 isci commits ago. Suspend/resume support has been implemented
and many bugs have been fixed since 1.1. Now update the version to 1.2.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
---
 drivers/scsi/isci/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index d25d0d8..695b34e 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -66,7 +66,7 @@
 #include "probe_roms.h"
 
 #define MAJ 1
-#define MIN 1
+#define MIN 2
 #define BUILD 0
 #define DRV_VERSION __stringify(MAJ) "." __stringify(MIN) "." \
 	__stringify(BUILD)

