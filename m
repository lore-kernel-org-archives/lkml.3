Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbaCDVHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:07:38 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:54307 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788AbaCDVHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:07:33 -0500
Subject: [PATCH 0/2] sched: Removed unused mc_capable() and smt_capable()
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-mips@linux-mips.org, linux-ia64@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Date: Tue, 04 Mar 2014 14:07:31 -0700
Message-ID: <20140304210621.16893.8772.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just cleanup of a couple unused interfaces and (for sparc64) a
supporting variable.

---

Bjorn Helgaas (2):
      sched: Remove unused mc_capable() and smt_capable()
      sparc64: Remove unused sparc64_multi_core


 arch/arm/include/asm/topology.h      |    3 ---
 arch/ia64/include/asm/topology.h     |    1 -
 arch/mips/include/asm/topology.h     |    4 ----
 arch/powerpc/include/asm/topology.h  |    1 -
 arch/sparc/include/asm/smp_64.h      |    1 -
 arch/sparc/include/asm/topology_64.h |    2 --
 arch/sparc/kernel/mdesc.c            |    4 ----
 arch/sparc/kernel/prom_64.c          |    3 ---
 arch/sparc/kernel/smp_64.c           |    2 --
 arch/x86/include/asm/topology.h      |    6 ------
 10 files changed, 27 deletions(-)
