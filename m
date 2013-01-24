Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3AXJWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:22:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:28561 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab3AXJV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:21:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,528,1355126400"; 
   d="scan'208";a="276013565"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/2] lockstat: fix a typo
Date: Thu, 24 Jan 2013 17:22:44 +0800
Message-Id: <1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be CONFIG_LOCK_STAT

Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 Documentation/lockstat.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/lockstat.txt b/Documentation/lockstat.txt
index cef00d4..dd2f7b2 100644
--- a/Documentation/lockstat.txt
+++ b/Documentation/lockstat.txt
@@ -65,7 +65,7 @@ that had to wait on lock acquisition.
 
  - CONFIGURATION
 
-Lock statistics are enabled via CONFIG_LOCK_STATS.
+Lock statistics are enabled via CONFIG_LOCK_STAT.
 
  - USAGE
 
-- 
1.7.7.6

