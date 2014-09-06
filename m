Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaIFRio (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 13:38:44 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:48347 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaIFRil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 13:38:41 -0400
From: Spencer Baugh <sbaugh@andrew.cmu.edu>
To: gregkh@linuxfoundation.org
Cc: Spencer Baugh <sbaugh@andrew.cmu.edu>, Oleg Drokin <oleg.drokin@intel.com>,
        Niu Yawei <yawei.niu@intel.com>,
        Hongchao Zhang <hongchao.zhang@intel.com>,
        Alex Zhuravlev <alexey.zhuravlev@intel.com>,
        Masanari Iida <standby24x7@gmail.com>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/3] staging: lustre: fix pointer whitespace style
Date: Sat,  6 Sep 2014 13:38:28 -0400
Message-Id: <1410025111-31422-2-git-send-email-sbaugh@andrew.cmu.edu>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410025111-31422-1-git-send-email-sbaugh@andrew.cmu.edu>
References: <1410025111-31422-1-git-send-email-sbaugh@andrew.cmu.edu>
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
index feb4291..b71877b 100644
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

