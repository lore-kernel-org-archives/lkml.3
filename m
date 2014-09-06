Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaIFRi7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 13:38:59 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:61548 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaIFRin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 13:38:43 -0400
From: Spencer Baugh <sbaugh@andrew.cmu.edu>
To: gregkh@linuxfoundation.org
Cc: Spencer Baugh <sbaugh@andrew.cmu.edu>, Oleg Drokin <oleg.drokin@intel.com>,
        Alex Zhuravlev <alexey.zhuravlev@intel.com>,
        Hongchao Zhang <hongchao.zhang@intel.com>,
        Masanari Iida <standby24x7@gmail.com>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/3] staging: lustre: remove trailing whitespace
Date: Sat,  6 Sep 2014 13:38:29 -0400
Message-Id: <1410025111-31422-3-git-send-email-sbaugh@andrew.cmu.edu>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410025111-31422-1-git-send-email-sbaugh@andrew.cmu.edu>
References: <1410025111-31422-1-git-send-email-sbaugh@andrew.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix errors reported by checkpatch of this kind:
ERROR: trailing whitespace

Signed-off-by: Spencer Baugh <sbaugh@andrew.cmu.edu>
---
 drivers/staging/lustre/lustre/include/lustre_import.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_import.h b/drivers/staging/lustre/lustre/include/lustre_import.h
index b71877b..51f3e98 100644
--- a/drivers/staging/lustre/lustre/include/lustre_import.h
+++ b/drivers/staging/lustre/lustre/include/lustre_import.h
@@ -346,7 +346,7 @@ static inline unsigned int at_timeout2est(unsigned int val)
 	return (max((val << 2) / 5, 5U) - 4);
 }
 
-static inline void at_reset(struct adaptive_timeout *at, int val) 
+static inline void at_reset(struct adaptive_timeout *at, int val)
 {
 	spin_lock(&at->at_lock);
 	at->at_current = val;
@@ -354,7 +354,7 @@ static inline void at_reset(struct adaptive_timeout *at, int val)
 	at->at_worst_time = get_seconds();
 	spin_unlock(&at->at_lock);
 }
-static inline void at_init(struct adaptive_timeout *at, int val, int flags) 
+static inline void at_init(struct adaptive_timeout *at, int val, int flags)
 {
 	memset(at, 0, sizeof(*at));
 	spin_lock_init(&at->at_lock);
@@ -362,7 +362,7 @@ static inline void at_init(struct adaptive_timeout *at, int val, int flags)
 	at_reset(at, val);
 }
 extern unsigned int at_min;
-static inline int at_get(struct adaptive_timeout *at) 
+static inline int at_get(struct adaptive_timeout *at)
 {
 	return (at->at_current > at_min) ? at->at_current : at_min;
 }
-- 
2.1.0

