Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab3GBUYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:24:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4154 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab3GBUY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:24:27 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=YR7xZDmnOGcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=y3g5F2ol7ZEA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=IfTij950QGM34LrluAUA:9 a=BShKF_HQrJQA:10 a=bv6CJ5m0Xf0A:10 a=-z0iSQ3b-QcA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130702202425.990308032@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 02 Jul 2013 16:22:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tom.zanussi@intel.com>
Subject: [for-next][PATCH 05/14] tracing: Add missing syscall_metadata comment
References: <20130702202216.623562799@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Add-missing-syscall_metadata-comment.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@intel.com>

Add the missing syscall_metadata description for the enter_fields
struct member.

Link: http://lkml.kernel.org/r/74c3407cd1e5d37f2c5aaca637aa4d35f66f1aa2.1372479499.git.tom.zanussi@linux.intel.com

Signed-off-by: Tom Zanussi <tom.zanussi@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/syscall.h |    1 +
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
1.7.10.4


