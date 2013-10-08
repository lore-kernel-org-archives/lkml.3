Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab3JHFNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:13:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab3JHFMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:12:47 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH v2 13/14] x86: select ARCH_MAY_HAVE_PC_PARPORT
Date: Tue,  8 Oct 2013 01:10:29 -0400
Message-Id: <1381209030-351-14-git-send-email-msalter@redhat.com>
In-Reply-To: <1381209030-351-1-git-send-email-msalter@redhat.com>
References: <1381209030-351-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures which support CONFIG_PARPORT_PC should select
ARCH_MAY_HAVE_PC_PARPORT.

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ee2fb9d..72fca40 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -22,6 +22,7 @@ config X86_64
 config X86
 	def_bool y
 	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	select ARCH_MAY_HAVE_PC_PARPORT
 	select HAVE_AOUT if X86_32
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select ARCH_SUPPORTS_NUMA_BALANCING
-- 
1.8.3.1

