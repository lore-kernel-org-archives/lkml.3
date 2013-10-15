Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920Ab3JOVGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:06:13 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:44897 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933816Ab3JOVEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:04:52 -0400
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/13] ARM: Remove uprobes dependency on kprobes
Date: Tue, 15 Oct 2013 17:04:28 -0400
Message-Id: <1381871068-27660-14-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
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
index 5b2cc2b..5f4b5d1 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -199,7 +199,6 @@ config NEED_DMA_MAP_STATE
        def_bool y
 
 config ARCH_SUPPORTS_UPROBES
-	depends on KPROBES
 	def_bool y
 
 config ARCH_HAS_DMA_SET_COHERENT_MASK
-- 
1.8.1.2

