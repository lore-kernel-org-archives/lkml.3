Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaCMOkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:40:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:56734 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbaCMOkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:40:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,647,1389772800"; 
   d="scan'208";a="471668972"
Subject: [PATCH] MAINTAINERS: update Intel C600 SAS driver maintainers
From: Lukasz Dorau <lukasz.dorau@intel.com>
To: torvalds@linux-foundation.org
Cc: jejb@kernel.org, dave.jiang@intel.com, maciej.patelczyk@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lukasz.dorau@intel.com, artur.paszkiewicz@intel.com,
        intel-linux-scu@intel.com
Date: Thu, 13 Mar 2014 15:39:38 +0100
Message-ID: <20140313143938.6769.81556.stgit@gklab-154-244.igk.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1ecfde1..cf59068 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4458,8 +4458,7 @@ K:	\b(ABS|SYN)_MT_
 
 INTEL C600 SERIES SAS CONTROLLER DRIVER
 M:	Intel SCU Linux support <intel-linux-scu@intel.com>
-M:	Lukasz Dorau <lukasz.dorau@intel.com>
-M:	Maciej Patelczyk <maciej.patelczyk@intel.com>
+M:	Artur Paszkiewicz <artur.paszkiewicz@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
 L:	linux-scsi@vger.kernel.org
 T:	git git://git.code.sf.net/p/intel-sas/isci

