Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3LRKYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:24:17 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:41111 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab3LRKYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:24:16 -0500
Date: Wed, 18 Dec 2013 11:24:12 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Shi <alex.shi@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/4] Fix ebizzy performance regression due to X86 TLB
 range flush v2
Message-ID: <20131218102412.GC20360@gmail.com>
References: <CA+55aFyNAigQqBk07xLpf0nkhZ_x-QkBYG8otRzsqg_8A2eg-Q@mail.gmail.com>
 <20131215155539.GM11295@suse.de>
 <20131216102439.GA21624@gmail.com>
 <20131216125923.GS11295@suse.de>
 <20131216134449.GA3034@gmail.com>
 <20131217092124.GV11295@suse.de>
 <20131217110051.GA27701@gmail.com>
 <20131217143253.GB11295@suse.de>
 <20131217144214.GA12370@gmail.com>
 <20131217175441.GI11295@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217175441.GI11295@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> > Thanks again for going through all this. Tracking multi-commit 
> > performance regressions across 1.5 years worth of commits is 
> > generally very hard. Does your testing effort comes from 
> > enterprise Linux QA testing, or did you ran into this problem 
> > accidentally?
> 
> It does not come from enterprise Linux QA testing but it's motivated 
> by it. I want to catch as many "obvious" performance bugs before 
> they do as it saves time and stress in the long run. To assist that, 
> I setup continual performance regression testing and ebizzy was 
> included in the first report I opened. [...]

Neat!

> [...]  It makes me worry what the rest of the reports contain.

It will be full with reports of phenomenal speedups!

Thanks,

	Ingo
