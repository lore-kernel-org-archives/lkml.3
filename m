Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaIPRnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 13:43:12 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:47232 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754706AbaIPRnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:43:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkMOADV2GFRXQAMM/2dsb2JhbABggw2BKrQRBQFvmxiBFBcBeYRgI4EaN4hCAbw0hXyIa2QdhDUFnQqMMYkUg2A7L4EGgUQBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Dave Chinner <david@fromorbit.com>,
        xfs@oss.sgi.com
Subject: [PATCH 1/1] xfs: remove second xfs_quota.h inclusion in xfs_icache.c
Date: Tue, 16 Sep 2014 19:42:24 +0200
Message-Id: <1410889344-28339-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xfs_quota.h was included twice.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/xfs/xfs_icache.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 981b2cf..b45f7b2 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -33,7 +33,6 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_bmap_util.h"
-#include "xfs_quota.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 
-- 
2.1.0

