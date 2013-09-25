Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab3IYOJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:09:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33795 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab3IYOJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:09:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/spinlock: Document the xen_nopvspin parameter.
Date: Wed, 25 Sep 2013 10:09:30 -0400
Message-Id: <1380118170-5262-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which disables in the ticketlock slowpath the Xen PV optimization's.
Useful for diagnosing issues and comparing benchmarks in
over-commit CPU scenarios.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 Documentation/kernel-parameters.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7f9d4f5..b958912 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3412,6 +3412,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 				the unplug protocol
 			never -- do not unplug even if version check succeeds
 
+	xen_nopvspin	[X86,XEN]
+			Disables the ticketlock slowpath using Xen PV
+			optimizations.
+
 	xirc2ps_cs=	[NET,PCMCIA]
 			Format:
 			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
-- 
1.8.3.1

