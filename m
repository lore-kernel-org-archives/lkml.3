Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3BDInR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:43:17 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16718 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3BDInQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:43:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Feb 2013 00:42:51 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] regmap: fix compilation error
Date: Mon, 4 Feb 2013 14:14:02 +0530
Message-ID: <1359967442-23672-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a compilation error is seen due to missing header file
in next-20130204, fixing it.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/base/regmap/regmap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index bee8560..ebd1f22 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -16,6 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/err.h>
 #include <linux/rbtree.h>
+#include <linux/sched.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/regmap.h>
-- 
1.7.0.4

