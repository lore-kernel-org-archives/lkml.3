Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaJ0L5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:57:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:5380 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbaJ0L5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:57:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,795,1406617200"; 
   d="scan'208";a="612028079"
From: Andi Kleen <andi@firstfloor.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, eranian@google.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "Yan\, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH 2/5] perf, x86, uncore: Add Haswell-EP uncore support
References: <1409872109-31645-1-git-send-email-andi@firstfloor.org>
	<1409872109-31645-2-git-send-email-andi@firstfloor.org>
	<CAADnVQKWgm9smg5vtfFwt53RiNYidgV9kiq3C0B0Xekx0cUJJg@mail.gmail.com>
Date: Mon, 27 Oct 2014 04:57:41 -0700
In-Reply-To: <CAADnVQKWgm9smg5vtfFwt53RiNYidgV9kiq3C0B0Xekx0cUJJg@mail.gmail.com>
	(Alexei Starovoitov's message of "Wed, 22 Oct 2014 12:07:56 -0700")
Message-ID: <87sii9pvwq.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> my E5-1630 v3 crashes hard during boot in
> snbep_uncore_msr_init_box()+0x3c

> I don't have a setup to capture the screen so early in the boot.
> So this is just heads up.

Is it a general general protection fault or a page fault?

If it's a page fault please post the disassembled code:

gdb vmlinux
disassemble  snbep_uncore_msr_init_box

> I replaced the call above with 'return -ENODEV' as a workaround.
> btw, E5-16xx v3 became available just a month ago.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
