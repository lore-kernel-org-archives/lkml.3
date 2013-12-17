Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab3LQGMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 01:12:17 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:43120 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3LQGLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 01:11:39 -0500
X-AuditID: 9c93017e-b7c17ae000003961-38-52afeb186d73
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 3/5] zsmalloc: add copyright
Date: Tue, 17 Dec 2013 15:12:01 +0900
Message-Id: <1387260723-15817-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387260723-15817-1-git-send-email-minchan@kernel.org>
References: <1387260723-15817-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add my copyright to the zsmalloc source code which I maintain.

Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/zsmalloc.h |    1 +
 mm/zsmalloc.c            |    1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index c2eb174b97ee..e44d634e7fb7 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -2,6 +2,7 @@
  * zsmalloc memory allocator
  *
  * Copyright (C) 2011  Nitin Gupta
+ * Copyright (C) 2012, 2013 Minchan Kim
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the license that better fits your requirements.
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 0202716ff6c2..faa6fd801110 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -2,6 +2,7 @@
  * zsmalloc memory allocator
  *
  * Copyright (C) 2011  Nitin Gupta
+ * Copyright (C) 2012, 2013 Minchan Kim
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the license that better fits your requirements.
-- 
1.7.9.5

