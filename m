Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaCJOTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:19:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:34259 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801AbaCJOTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:19:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,624,1389772800"; 
   d="scan'208";a="469590581"
Subject: [PATCH RESEND] isci: update version to 1.2
From: Lukasz Dorau <lukasz.dorau@intel.com>
To: jejb@kernel.org
Cc: lukasz.dorau@intel.com, dave.jiang@intel.com, maciej.patelczyk@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Mar 2014 15:18:51 +0100
Message-ID: <20140310141851.12177.63945.stgit@gklab-154-244.igk.intel.com>
User-Agent: StGit/0.17.1-dirty
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
 1 files changed, 1 insertions(+), 1 deletions(-)

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

