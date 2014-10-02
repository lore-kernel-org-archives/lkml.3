Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbaJBPE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:04:58 -0400
Received: from one.firstfloor.org ([193.170.194.197]:41557 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaJBPE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:04:56 -0400
Date: Thu, 2 Oct 2014 17:04:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v2 00/11] perf: Intel Cache QoS Monitoring support
Message-ID: <20141002150454.GA12538@two.firstfloor.org>
References: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
 <8738b7eac2.fsf@tassilo.jf.intel.com>
 <20141002065124.GF14343@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002065124.GF14343@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I didn't include support for that because none of the other x86 pmu
> drivers are buildable as modules. Is there a reason for that?

Not done yet. 

Uncore drivers are definitely on the list.

> It's much simpler to just build it in and enable it based on
> CONFIG_PERF_EVENTS + CONFIG_INTEL_CPU. In fact, that's one of the things

> I've always liked about the pmu drivers, if I move to a new machine and
> turn on PERF_EVENTS the correct drivers will be run.

Yes, we should just get rid of Kconfig and give everyone
the same kernel like Windows. Much simpler for everyone, 
wouldn't it be?

I'm sure you can easily see the flaws in the argument.

BTW CONFIG_PERF_EVENTS cannot be disabled on x86 currently,
so right now the only way to not get CQM would be to 
not support Intel CPUs ...

-Andi
