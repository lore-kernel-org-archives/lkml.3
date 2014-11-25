Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaKYT0C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:26:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbaKYTZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:25:59 -0500
Subject: [PATCH v6 5/5] patch to allow arm cross-compile
From: Alexander Duyck <alexander.h.duyck@redhat.com>
To: linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, peterz@infradead.org,
        benh@kernel.crashing.org, heiko.carstens@de.ibm.com, mingo@kernel.org,
        mikey@neuling.org, linux@arm.linux.org.uk, donald.c.skidmore@intel.com,
        matthew.vick@intel.com, geert@linux-m68k.org,
        jeffrey.t.kirsher@intel.com, romieu@fr.zoreil.com,
        paulmck@linux.vnet.ibm.com, nic_swsd@realtek.com, arnd@arndb.de,
        will.deacon@arm.com, michael@ellerman.id.au, tony.luck@intel.com,
        torvalds@linux-foundation.org, oleg@redhat.com, schwidefsky@de.ibm.com,
        fweisbec@gmail.com, davem@davemloft.net
Date: Tue, 25 Nov 2014 10:33:22 -0800
Message-ID: <20141125183322.1486.90766.stgit@ahduyck-server>
In-Reply-To: <20141125183009.1486.20845.stgit@ahduyck-server>
References: <20141125183009.1486.20845.stgit@ahduyck-server>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---
 arch/arm/kernel/asm-offsets.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 2d2d608..6f8e79c 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -49,10 +49,6 @@
 #error Your compiler is too buggy; it is known to miscompile kernels.
 #error    Known good compilers: 3.3, 4.x
 #endif
-#if GCC_VERSION >= 40800 && GCC_VERSION < 40803
-#error Your compiler is too buggy; it is known to miscompile kernels
-#error and result in filesystem corruption and oopses.
-#endif
 #endif
 
 int main(void)

