Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbbAWQPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:15:24 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:37144 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbbAWQOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:14:51 -0500
X-IronPort-AV: E=Sophos;i="5.09,454,1418083200"; 
   d="scan'208";a="220908770"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        <xen-devel@lists.xenproject.org>
Subject: [PATCH] xen-blk: add myself as maintainer of xen-blk{back/front}
Date: Fri, 23 Jan 2015 17:14:29 +0100
Message-ID: <1422029669-24845-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.9.3 (Apple Git-50)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've done quite a lot of work in blkfront/blkback, and I usually end up
looking at the patches, so add myself as maintainer together with Konrad.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xenproject.org
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c721042..96e129c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10351,6 +10351,7 @@ F:	drivers/pci/*xen*
 
 XEN BLOCK SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+M:	Roger Pau Monné <roger.pau@citrix.com>
 L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
 S:	Supported
 F:	drivers/block/xen-blkback/*
-- 
1.9.3 (Apple Git-50)

