Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbaCTNJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:09:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:55199 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758335AbaCTNJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:09:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,694,1389772800"; 
   d="scan'208";a="495808487"
Date: Thu, 20 Mar 2014 20:35:46 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: linux-rdma@vger.kernel.org
Cc: CQ Tang <cq.tang@intel.com>, Roland Dreier <roland@purestorage.com>,
        linux-kernel@vger.kernel.org,
        "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: [PATCH infiniband] IB/qib: qib_user_sdma_rb_root can be static
Message-ID: <20140320123546.GA11076@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: CQ Tang <cq.tang@intel.com>
CC: Roland Dreier <roland@purestorage.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 qib_user_sdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index b225645..d2806ca 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -55,7 +55,7 @@
 /*
  * track how many times a process open this driver.
  */
-struct rb_root qib_user_sdma_rb_root = RB_ROOT;
+static struct rb_root qib_user_sdma_rb_root = RB_ROOT;
 
 struct qib_user_sdma_rb_node {
 	struct rb_node node;


