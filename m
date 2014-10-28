Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaJ1Pap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:30:45 -0400
Received: from one.firstfloor.org ([193.170.194.197]:51400 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbaJ1Pao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:30:44 -0400
Date: Tue, 28 Oct 2014 16:30:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH 2/5] perf, x86, uncore: Add Haswell-EP uncore support
Message-ID: <20141028153042.GV12538@two.firstfloor.org>
References: <CAADnVQ+bZdb5wETaj8b8WYnZD4Myhexy8iHDoxsu3-srZwyRxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+bZdb5wETaj8b8WYnZD4Myhexy8iHDoxsu3-srZwyRxQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> snbep_uncore_msr_init_box() is called with:
> [    1.055678] msr 0
> [    1.056027] msr 3584
> [    1.056376] msr 3600
> [    1.056725] msr 3616
> [    1.057074] msr 3632
> [    1.057424] msr 1824

So it would normally crash here, right? That's the SBOX.

When you remove the sbox in hswep_msr_uncores the crash goes away,
correct?


-Andi
