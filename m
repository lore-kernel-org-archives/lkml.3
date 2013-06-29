Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3F2FKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 01:10:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:47426 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab3F2FKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 01:10:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,963,1363158000"; 
   d="scan'208";a="324201279"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, jovi.zhangwei@huawei.com,
        linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@intel.com>
Subject: [PATCH v2 02/11] tracing: add missing syscall_metadata comment
Date: Sat, 29 Jun 2013 00:08:05 -0500
Message-Id: <74c3407cd1e5d37f2c5aaca637aa4d35f66f1aa2.1372479499.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1372479499.git.tom.zanussi@linux.intel.com>
References: <cover.1372479499.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1372479499.git.tom.zanussi@linux.intel.com>
References: <cover.1372479499.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@intel.com>

Add the missing syscall_metadata description for the enter_fields
struct member.

Signed-off-by: Tom Zanussi <tom.zanussi@intel.com>
---
 include/trace/syscall.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 84bc419..fed853f 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -16,6 +16,7 @@
  * @nb_args: number of parameters it takes
  * @types: list of types as strings
  * @args: list of args as strings (args[i] matches types[i])
+ * @enter_fields: list of fields for syscall_enter trace event
  * @enter_event: associated syscall_enter trace event
  * @exit_event: associated syscall_exit trace event
  */
-- 
1.7.11.4

