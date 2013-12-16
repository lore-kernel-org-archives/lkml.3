Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab3LPEJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 23:09:58 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:40912 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab3LPEJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 23:09:22 -0500
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
Subject: [PATCH v4 16/16] ARM: Remove uprobes dependency on kprobes
Date: Sun, 15 Dec 2013 23:08:50 -0500
Message-Id: <1387166930-13182-17-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387166930-13182-1-git-send-email-dave.long@linaro.org>
References: <1387166930-13182-1-git-send-email-dave.long@linaro.org>
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

