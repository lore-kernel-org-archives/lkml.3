Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaFKJoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:44:24 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:65436 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763AbaFKJoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:44:22 -0400
Message-ID: <1402479861.3798.63.camel@x220>
Subject: [PATCH] [linux-next] arm64: ftrace: Fix comment typo
 'CONFIG_FUNCTION_GRAPH_FP_TEST'
From: Paul Bolle <pebolle@tiscali.nl>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 11 Jun 2014 11:44:21 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2014 09:44:22.0014 (UTC) FILETIME=[B90B41E0:01CF8559]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

This typo was added in next-20140603. I've had this patch queued for
over a week because I wanted to understand the comment I'm touching
here. I still don't. But I figured that making sure that this comment
uses the Kconfig macro that apparently was intended, ought to be enough
to submit this.

 arch/arm64/kernel/entry-ftrace.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index b051871f2965..aa5f9fcbf9ee 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -205,7 +205,7 @@ ENDPROC(ftrace_graph_caller)
  *
  * Run ftrace_return_to_handler() before going back to parent.
  * @fp is checked against the value passed by ftrace_graph_caller()
- * only when CONFIG_FUNCTION_GRAPH_FP_TEST is enabled.
+ * only when CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST is enabled.
  */
 ENTRY(return_to_handler)
 	str	x0, [sp, #-16]!
-- 
1.9.3

