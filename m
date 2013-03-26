Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab3CZRn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:43:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21625 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab3CZRgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:24 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=7xENY_tlolcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=T15eFSYl0SUA:10 a=J1Y8HTJGAAAA:8 a=VnNF1IyMAAAA:8 a=AqJ00D3vZjHJZuhkqGEA:9 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173612.285442234@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 78/86] sparc64: Add missing HAVE_ARCH_TRANSPARENT_HUGEPAGE.
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0078-sparc64-Add-missing-HAVE_ARCH_TRANSPARENT_HUGEPAGE.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit f53f5f1e2a84c2a95c47f28b0859ef5eee34569d ]

This got missed in the cleanups done for the S390 THP
support.

CC: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 67f1f6f..0133b1b 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -56,6 +56,7 @@ config SPARC64
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_SYSCALL_WRAPPERS
+	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_SYSCALL_TRACEPOINTS
-- 
1.7.10.4


