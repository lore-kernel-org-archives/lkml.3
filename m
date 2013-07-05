Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab3GEQ3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:29:32 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:48181 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3GEQ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:29:30 -0400
Subject: [PATCH 0/3] smp/ipi: Minor cleanups in smp_call_function variants
To: xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: npiggin@suse.de, deepthi@linux.vnet.ibm.com, peterz@infradead.org,
        rusty@rustcorp.com.au, heiko.carstens@de.ibm.com, udknight@gmail.com,
        rostedt@goodmis.org, miltonm@bga.com, srivatsa.bhat@linux.vnet.ibm.com,
        jens.axboe@oracle.com, tj@kernel.org, akpm@linux-foundation.org,
        svaidy@linux.vnet.ibm.com, shli@kernel.org, tglx@linutronix.de,
        lig.fnst@cn.fujitsu.com, anton@samba.org
Date: Fri, 05 Jul 2013 21:56:52 +0530
Message-ID: <20130705162548.16888.18957.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070516-8878-0000-0000-000007D56C08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset removes possible stale code overlooked by previous
cleanups. It also clarifies ambiguous comments about deadlock scenarios
while calling smp_call_function variants, as they were not obvious at a first
glance.

---

Preeti U Murthy (3):
      smp/ipi: Remove redundant cfd->cpumask_ipi mask
      smp/ipi:Clarify ambiguous comments around deadlock scenarios in smp_call_function variants.
      smp/ipi:Remove check around csd lock in handler for smp_call_function variants


 kernel/smp.c |   74 ++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 28 deletions(-)

-- 
Signature

