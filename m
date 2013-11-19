Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab3KSN2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:28:15 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:59173 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3KSN0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:26:24 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <tao.peng@emc.com>,
        Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 3/9] drivers/staging/lustre: indent lustre_ldlm_flags_vals
Date: Tue, 19 Nov 2013 21:23:42 +0800
Message-Id: <1384867428-8395-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
References: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <tao.peng@emc.com>

To follow kernel's "no spaces at the start of a line" rule.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/lustre/include/lustre_dlm_flags.h       |   80 ++++++++++----------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm_flags.h b/drivers/staging/lustre/lustre/include/lustre_dlm_flags.h
index f8b4ba7..75716f1 100644
--- a/drivers/staging/lustre/lustre/include/lustre_dlm_flags.h
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm_flags.h
@@ -423,46 +423,46 @@ static int hf_lustre_ldlm_fl_ns_srv              = -1;
 static int hf_lustre_ldlm_fl_excl                = -1;
 
 const value_string lustre_ldlm_flags_vals[] = {
-  {LDLM_FL_LOCK_CHANGED,        "LDLM_FL_LOCK_CHANGED"},
-  {LDLM_FL_BLOCK_GRANTED,       "LDLM_FL_BLOCK_GRANTED"},
-  {LDLM_FL_BLOCK_CONV,          "LDLM_FL_BLOCK_CONV"},
-  {LDLM_FL_BLOCK_WAIT,          "LDLM_FL_BLOCK_WAIT"},
-  {LDLM_FL_AST_SENT,            "LDLM_FL_AST_SENT"},
-  {LDLM_FL_REPLAY,              "LDLM_FL_REPLAY"},
-  {LDLM_FL_INTENT_ONLY,         "LDLM_FL_INTENT_ONLY"},
-  {LDLM_FL_HAS_INTENT,          "LDLM_FL_HAS_INTENT"},
-  {LDLM_FL_DISCARD_DATA,        "LDLM_FL_DISCARD_DATA"},
-  {LDLM_FL_NO_TIMEOUT,          "LDLM_FL_NO_TIMEOUT"},
-  {LDLM_FL_BLOCK_NOWAIT,        "LDLM_FL_BLOCK_NOWAIT"},
-  {LDLM_FL_TEST_LOCK,           "LDLM_FL_TEST_LOCK"},
-  {LDLM_FL_CANCEL_ON_BLOCK,     "LDLM_FL_CANCEL_ON_BLOCK"},
-  {LDLM_FL_DENY_ON_CONTENTION,  "LDLM_FL_DENY_ON_CONTENTION"},
-  {LDLM_FL_AST_DISCARD_DATA,    "LDLM_FL_AST_DISCARD_DATA"},
-  {LDLM_FL_FAIL_LOC,            "LDLM_FL_FAIL_LOC"},
-  {LDLM_FL_SKIPPED,             "LDLM_FL_SKIPPED"},
-  {LDLM_FL_CBPENDING,           "LDLM_FL_CBPENDING"},
-  {LDLM_FL_WAIT_NOREPROC,       "LDLM_FL_WAIT_NOREPROC"},
-  {LDLM_FL_CANCEL,              "LDLM_FL_CANCEL"},
-  {LDLM_FL_LOCAL_ONLY,          "LDLM_FL_LOCAL_ONLY"},
-  {LDLM_FL_FAILED,              "LDLM_FL_FAILED"},
-  {LDLM_FL_CANCELING,           "LDLM_FL_CANCELING"},
-  {LDLM_FL_LOCAL,               "LDLM_FL_LOCAL"},
-  {LDLM_FL_LVB_READY,           "LDLM_FL_LVB_READY"},
-  {LDLM_FL_KMS_IGNORE,          "LDLM_FL_KMS_IGNORE"},
-  {LDLM_FL_CP_REQD,             "LDLM_FL_CP_REQD"},
-  {LDLM_FL_CLEANED,             "LDLM_FL_CLEANED"},
-  {LDLM_FL_ATOMIC_CB,           "LDLM_FL_ATOMIC_CB"},
-  {LDLM_FL_BL_AST,              "LDLM_FL_BL_AST"},
-  {LDLM_FL_BL_DONE,             "LDLM_FL_BL_DONE"},
-  {LDLM_FL_NO_LRU,              "LDLM_FL_NO_LRU"},
-  {LDLM_FL_FAIL_NOTIFIED,       "LDLM_FL_FAIL_NOTIFIED"},
-  {LDLM_FL_DESTROYED,           "LDLM_FL_DESTROYED"},
-  {LDLM_FL_SERVER_LOCK,         "LDLM_FL_SERVER_LOCK"},
-  {LDLM_FL_RES_LOCKED,          "LDLM_FL_RES_LOCKED"},
-  {LDLM_FL_WAITED,              "LDLM_FL_WAITED"},
-  {LDLM_FL_NS_SRV,              "LDLM_FL_NS_SRV"},
-  {LDLM_FL_EXCL,                "LDLM_FL_EXCL"},
-  { 0, NULL }
+	{LDLM_FL_LOCK_CHANGED,        "LDLM_FL_LOCK_CHANGED"},
+	{LDLM_FL_BLOCK_GRANTED,       "LDLM_FL_BLOCK_GRANTED"},
+	{LDLM_FL_BLOCK_CONV,          "LDLM_FL_BLOCK_CONV"},
+	{LDLM_FL_BLOCK_WAIT,          "LDLM_FL_BLOCK_WAIT"},
+	{LDLM_FL_AST_SENT,            "LDLM_FL_AST_SENT"},
+	{LDLM_FL_REPLAY,              "LDLM_FL_REPLAY"},
+	{LDLM_FL_INTENT_ONLY,         "LDLM_FL_INTENT_ONLY"},
+	{LDLM_FL_HAS_INTENT,          "LDLM_FL_HAS_INTENT"},
+	{LDLM_FL_DISCARD_DATA,        "LDLM_FL_DISCARD_DATA"},
+	{LDLM_FL_NO_TIMEOUT,          "LDLM_FL_NO_TIMEOUT"},
+	{LDLM_FL_BLOCK_NOWAIT,        "LDLM_FL_BLOCK_NOWAIT"},
+	{LDLM_FL_TEST_LOCK,           "LDLM_FL_TEST_LOCK"},
+	{LDLM_FL_CANCEL_ON_BLOCK,     "LDLM_FL_CANCEL_ON_BLOCK"},
+	{LDLM_FL_DENY_ON_CONTENTION,  "LDLM_FL_DENY_ON_CONTENTION"},
+	{LDLM_FL_AST_DISCARD_DATA,    "LDLM_FL_AST_DISCARD_DATA"},
+	{LDLM_FL_FAIL_LOC,            "LDLM_FL_FAIL_LOC"},
+	{LDLM_FL_SKIPPED,             "LDLM_FL_SKIPPED"},
+	{LDLM_FL_CBPENDING,           "LDLM_FL_CBPENDING"},
+	{LDLM_FL_WAIT_NOREPROC,       "LDLM_FL_WAIT_NOREPROC"},
+	{LDLM_FL_CANCEL,              "LDLM_FL_CANCEL"},
+	{LDLM_FL_LOCAL_ONLY,          "LDLM_FL_LOCAL_ONLY"},
+	{LDLM_FL_FAILED,              "LDLM_FL_FAILED"},
+	{LDLM_FL_CANCELING,           "LDLM_FL_CANCELING"},
+	{LDLM_FL_LOCAL,               "LDLM_FL_LOCAL"},
+	{LDLM_FL_LVB_READY,           "LDLM_FL_LVB_READY"},
+	{LDLM_FL_KMS_IGNORE,          "LDLM_FL_KMS_IGNORE"},
+	{LDLM_FL_CP_REQD,             "LDLM_FL_CP_REQD"},
+	{LDLM_FL_CLEANED,             "LDLM_FL_CLEANED"},
+	{LDLM_FL_ATOMIC_CB,           "LDLM_FL_ATOMIC_CB"},
+	{LDLM_FL_BL_AST,              "LDLM_FL_BL_AST"},
+	{LDLM_FL_BL_DONE,             "LDLM_FL_BL_DONE"},
+	{LDLM_FL_NO_LRU,              "LDLM_FL_NO_LRU"},
+	{LDLM_FL_FAIL_NOTIFIED,       "LDLM_FL_FAIL_NOTIFIED"},
+	{LDLM_FL_DESTROYED,           "LDLM_FL_DESTROYED"},
+	{LDLM_FL_SERVER_LOCK,         "LDLM_FL_SERVER_LOCK"},
+	{LDLM_FL_RES_LOCKED,          "LDLM_FL_RES_LOCKED"},
+	{LDLM_FL_WAITED,              "LDLM_FL_WAITED"},
+	{LDLM_FL_NS_SRV,              "LDLM_FL_NS_SRV"},
+	{LDLM_FL_EXCL,                "LDLM_FL_EXCL"},
+	{ 0, NULL }
 };
 #endif /*  WIRESHARK_COMPILE */
 #endif /* LDLM_ALL_FLAGS_MASK */
-- 
1.7.9.5

