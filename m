Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbbAFThD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:37:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:33737 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbbAFTgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:36:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="508307483"
Date: Wed, 7 Jan 2015 03:35:56 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH target] nvme_of: nvme_of_fabric_configfs can be static
Message-ID: <20150106193556.GA50610@snb>
References: <201501070334.EgwC5iey%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501070334.EgwC5iey%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/target/nvme_of/nvme_of_configfs.c:25:31: sparse: symbol 'nvme_of_fabric_configfs' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 nvme_of_configfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/nvme_of/nvme_of_configfs.c b/drivers/target/nvme_of/nvme_of_configfs.c
index c34603c..43a3abc1 100644
--- a/drivers/target/nvme_of/nvme_of_configfs.c
+++ b/drivers/target/nvme_of/nvme_of_configfs.c
@@ -22,7 +22,7 @@
 #include "nvme_of_fabric.h"
 
 /* Local pointer to allocated TCM configfs fabric module */
-struct target_fabric_configfs *nvme_of_fabric_configfs;
+static struct target_fabric_configfs *nvme_of_fabric_configfs;
 
 static struct se_node_acl *nvme_of_make_nodeacl(
 	struct se_portal_group *se_tpg,
