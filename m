Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791Ab3FNCjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:39:53 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52370 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759774Ab3FNCjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:39:51 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 11/33] infiniband: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:36 -0700
Message-Id: <fac2bd9d6dd26f566c8c09f0e8344822b3feb469.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/core/ucma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 5ca44cd..9416280 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -55,7 +55,7 @@ MODULE_LICENSE("Dual BSD/GPL");
 static unsigned int max_backlog = 1024;
 
 static struct ctl_table_header *ucma_ctl_table_hdr;
-static ctl_table ucma_ctl_table[] = {
+static struct ctl_table ucma_ctl_table[] = {
 	{
 		.procname	= "max_backlog",
 		.data		= &max_backlog,
-- 
1.8.1.2.459.gbcd45b4.dirty

