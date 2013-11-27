Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab3K0Cyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:54:31 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:51495 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363Ab3K0CyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:54:04 -0500
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 15/15] ARM: Remove uprobes dependency on kprobes
Date: Tue, 26 Nov 2013 21:53:34 -0500
Message-Id: <1385520814-10663-16-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
References: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Now that arm uprobes support has been made separate from the arm kprobes code
the Kconfig can be changed to reflect that.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index fec5a6b..9ddc4ae 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -204,7 +204,6 @@ config NEED_DMA_MAP_STATE
        def_bool y
 
 config ARCH_SUPPORTS_UPROBES
-	depends on KPROBES
 	def_bool y
 
 config ARCH_HAS_DMA_SET_COHERENT_MASK
-- 
1.8.1.2

