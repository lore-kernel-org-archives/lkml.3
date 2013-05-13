Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3EMNur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 09:50:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:16444 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab3EMNuq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 09:50:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,662,1363158000"; 
   d="scan'208";a="333261863"
From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "vishal.l.verma@linux.intel.com" <vishal.l.verma@linux.intel.com>,
        "Busch, Keith" <keith.busch@intel.com>
Subject: RE: [PATCH 1/1] NVMe: Remove redundant version.h header include
Thread-Topic: [PATCH 1/1] NVMe: Remove redundant version.h header include
Thread-Index: AQHOT5WVmF+0Ryw80k6njESkciNgBZkDIiJ7
Date: Mon, 13 May 2013 13:50:44 +0000
Message-ID: <100D68C7BA14664A8938383216E40DE027F80E97@fmsmsx111.amr.corp.intel.com>
References: <1368419898-25493-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1368419898-25493-1-git-send-email-sachin.kamat@linaro.org>
Accept-Language: en-CA, en-US
Content-Language: en-CA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't apply this patch.  Instead of following what it says in MAINTAINERS, you've sent it to my Exchange address.  And now it's all mangled.

NVM EXPRESS DRIVER
M:      Matthew Wilcox <willy@linux.intel.com>
L:      linux-nvme@lists.infradead.org

________________________________________
From: Sachin Kamat [sachin.kamat@linaro.org]
Sent: May 12, 2013 9:38 PM
To: linux-kernel@vger.kernel.org
Cc: Wilcox, Matthew R; vishal.l.verma@linux.intel.com; Busch, Keith; sachin.kamat@linaro.org
Subject: [PATCH 1/1] NVMe: Remove redundant version.h header include

version.h header inclusion is not necessary as detected by
checkversion.pl.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/block/nvme-scsi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/nvme-scsi.c b/drivers/block/nvme-scsi.c
index fed54b0..64bde68 100644
--- a/drivers/block/nvme-scsi.c
+++ b/drivers/block/nvme-scsi.c
@@ -44,7 +44,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <scsi/sg.h>
 #include <scsi/scsi.h>

--
1.7.9.5

