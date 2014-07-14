Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbaGNORT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:17:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34019 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaGNORK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:17:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        axboe@kernel.dk
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] MAINTAINERS: Make me the Xen block subsystem (front and back) maintainer
Date: Mon, 14 Jul 2014 10:17:02 -0400
Message-Id: <1405347422-5585-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The other MAINTAINER entries don't cover for this so the
xen-blkback driver looks like it is unmaintained. That is
not the case - but to make it obvious to tools - here is
the proper entry.

CC: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ebc8128..0e55123 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10008,6 +10008,13 @@ S:	Supported
 F:	arch/x86/pci/*xen*
 F:	drivers/pci/*xen*
 
+XEN BLOCK SUBSYSTEM
+M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
+S:	Supported
+F:	drivers/block/xen-blkback/*
+F:	drivers/block/xen*
+
 XEN SWIOTLB SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
 L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
-- 
1.9.3

