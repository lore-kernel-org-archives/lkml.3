Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbbAUQQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:16:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:34060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbbAUQPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:15:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,442,1418112000"; 
   d="scan'208";a="515468361"
Subject: [PATCH] MAINTAINERS: Remove self as isci maintainer
From: Dave Jiang <dave.jiang@intel.com>
To: linux-scsi@vger.kernel.org
Cc: artur.paszkiewicz@intel.com, linux-kernel@vger.kernel.org,
        daniej.j.thompson@intel.com
Date: Wed, 21 Jan 2015 09:13:41 -0700
Message-ID: <20150121161341.85869.90957.stgit@djiang5-desk2.amr.corp.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing myself as a maintainer.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93409ad..7e3d97a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4946,7 +4946,6 @@ K:	\b(ABS|SYN)_MT_
 INTEL C600 SERIES SAS CONTROLLER DRIVER
 M:	Intel SCU Linux support <intel-linux-scu@intel.com>
 M:	Artur Paszkiewicz <artur.paszkiewicz@intel.com>
-M:	Dave Jiang <dave.jiang@intel.com>
 L:	linux-scsi@vger.kernel.org
 T:	git git://git.code.sf.net/p/intel-sas/isci
 S:	Supported

