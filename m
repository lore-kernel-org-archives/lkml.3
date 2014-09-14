Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaINPWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 11:22:13 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:62443 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbaINPWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 11:22:10 -0400
From: Spencer Baugh <sbaugh@andrew.cmu.edu>
To: gregkh@linuxfoundation.org
Cc: Spencer Baugh <sbaugh@andrew.cmu.edu>, Oleg Drokin <oleg.drokin@intel.com>,
        Alex Zhuravlev <alexey.zhuravlev@intel.com>,
        Masanari Iida <standby24x7@gmail.com>, Niu Yawei <yawei.niu@intel.com>,
        Hongchao Zhang <hongchao.zhang@intel.com>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] staging: lustre: fix pointer whitespace style
Date: Sun, 14 Sep 2014 11:21:11 -0400
Message-Id: <1410708073-23713-2-git-send-email-sbaugh@andrew.cmu.edu>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410708073-23713-1-git-send-email-sbaugh@andrew.cmu.edu>
References: <1410708073-23713-1-git-send-email-sbaugh@andrew.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix errors reported by checkpatch of this kind:
ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Spencer Baugh <sbaugh@andrew.cmu.edu>
---
 drivers/staging/lustre/lustre/include/lustre_import.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_import.h b/drivers/staging/lustre/lustre/include/lustre_import.h
index 7bf82e0..51f3e98 100644
--- a/drivers/staging/lustre/lustre/include/lustre_import.h
+++ b/drivers/staging/lustre/lustre/include/lustre_import.h
@@ -103,9 +103,9 @@ enum lustre_imp_state {
 };
 
 /** Returns test string representation of numeric import state \a state */
-static inline char * ptlrpc_import_state_name(enum lustre_imp_state state)
+static inline char *ptlrpc_import_state_name(enum lustre_imp_state state)
 {
-	static char* import_state_names[] = {
+	static char *import_state_names[] = {
 		"<UNKNOWN>", "CLOSED",  "NEW", "DISCONN",
 		"CONNECTING", "REPLAY", "REPLAY_LOCKS", "REPLAY_WAIT",
 		"RECOVER", "FULL", "EVICTED",
-- 
2.1.0

