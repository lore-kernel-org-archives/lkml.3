Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaA3P56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:57:58 -0500
Received: from relay.parallels.com ([195.214.232.42]:34824 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaA3P54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:57:56 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <trivial@kernel.org>
CC: <tj@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH TRIVIAL] idr: remove unused prototype of idr_free()
Date: Thu, 30 Jan 2014 19:57:54 +0400
Message-ID: <1391097474-31300-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no such function. Remove the redundant prototype.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 include/linux/idr.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 871a213a8477..ff94a4875e1c 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -82,7 +82,6 @@ int idr_for_each(struct idr *idp,
 void *idr_get_next(struct idr *idp, int *nextid);
 void *idr_replace(struct idr *idp, void *ptr, int id);
 void idr_remove(struct idr *idp, int id);
-void idr_free(struct idr *idp, int id);
 void idr_destroy(struct idr *idp);
 void idr_init(struct idr *idp);
 
-- 
1.7.10.4

