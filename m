Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab3LQPuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:50:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab3LQPuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:50:05 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: [PATCH v2 09/10] x86: select ARCH_MIGHT_HAVE_PC_SERIO
Date: Tue, 17 Dec 2013 10:48:52 -0500
Message-Id: <1387295333-24684-10-git-send-email-msalter@redhat.com>
In-Reply-To: <1387295333-24684-1-git-send-email-msalter@redhat.com>
References: <1387295333-24684-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures which might use an i8042 for serial IO to keyboard,
mouse, etc should select ARCH_MIGHT_HAVE_PC_SERIO.

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: x86@kernel.org
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e903c71..b7f0903 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -23,6 +23,7 @@ config X86
 	def_bool y
 	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select ARCH_MIGHT_HAVE_PC_PARPORT
+	select ARCH_MIGHT_HAVE_PC_SERIO
 	select HAVE_AOUT if X86_32
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select ARCH_SUPPORTS_NUMA_BALANCING
-- 
1.8.3.1

