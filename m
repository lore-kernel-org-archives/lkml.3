Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab3AOHgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 02:36:06 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42691 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab3AOHgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 02:36:01 -0500
X-AuditID: 9c930179-b7b0cae0000065b4-5e-50f506e0ef7f
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, js1304@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] tools, vm: add .gitignore to ignore built binaries
Date: Tue, 15 Jan 2013 16:35:57 +0900
Message-Id: <1358235357-6126-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no .gitignore in tools/vm,
so 'git status' always show built binaries.
To ignore this, add .gitignore.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/tools/vm/.gitignore b/tools/vm/.gitignore
new file mode 100644
index 0000000..44f095f
--- /dev/null
+++ b/tools/vm/.gitignore
@@ -0,0 +1,2 @@
+slabinfo
+page-types
-- 
1.7.9.5

