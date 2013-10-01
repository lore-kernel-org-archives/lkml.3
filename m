Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab3JAIl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:41:28 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43185 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3JAIl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:41:26 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-66-524a8ab4d11c
Message-id: <524A8AB1.5040206@samsung.com>
Date: Tue, 01 Oct 2013 10:41:21 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] klist: fix a typo in klist_iter_init()
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsVy+t/xy7pburyCDOatkbK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZnd82shW8Yqv4sPM3UwPjFdYuRk4OCQETiYnfpjNB2GISF+6t
	Z+ti5OIQEljKKPHw+E9mCGcKk0Tbm42MIFW8AloSf2b9YQexWQRUJXY+ncwMYrMBTTq25DNY
	jahAhMSf0/tYIeoFJX5MvscCYosIKEhs7n0GFhcWMJeYcX01WD2zgI7E/tZpbBC2vMTmNW+Z
	JzDyzkLSPgtJ2SwkZQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihITOlx2Mi49ZHWIU
	4GBU4uE1qPcMEmJNLCuuzD3EKMHBrCTC21bhFSTEm5JYWZValB9fVJqTWnyIkYmDU6qBMb50
	8W3PkxzLFZMcnqxk3fXPd1p/8R7D+buy9aOif70MnyN1fUFY1pGqKWss55d6Tw74/m36dZtc
	D5MzL8/fT5X0evPhHd/ue08sVt85vOCki0H2GmbR+n/SjJExvF7i2zdMe6b7PXO39mvXJN+M
	uROtnxrtvVW48+zFVUYe6oYHj+Teir67c48SS3FGoqEWc1FxIgCY4+ZL+wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c8e5d14b1e7a010695d87b60759aeeacdf9e599a Mon Sep 17 00:00:00 2001
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Date: Tue, 1 Oct 2013 10:34:35 +0200
Subject: [PATCH] klist: fix a typo in klist_iter_init()

Fix a typo in comments for klist_iter_init().

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 lib/klist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/klist.c b/lib/klist.c
index 358a368..e0dc621 100644
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -289,7 +289,7 @@ void klist_iter_init_node(struct klist *k, struct klist_iter *i,
 EXPORT_SYMBOL_GPL(klist_iter_init_node);

 /**
- * klist_iter_init - Iniitalize a klist_iter structure.
+ * klist_iter_init - Initialize a klist_iter structure.
  * @k: klist we're iterating.
  * @i: klist_iter structure we're filling.
  *
-- 
1.7.9.5

