Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbbAGPvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:51:50 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:40180 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbbAGPvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:51:49 -0500
MIME-Version: 1.0
In-Reply-To: <20150107121340.GB3984@pd.tnic>
References: <CALCETrV6=aWoAckieQkPJ4BCr9VzU=9080EmLfeL4ZWm+Hr55g@mail.gmail.com>
 <54ab2ffa301102cd6e@agluck-desk.sc.intel.com> <CALCETrV+mchcQ5SgBO8+xLvw9rrHm4yvq+wZtQsD1EMMGzAMEw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3299127A@ORSMSX114.amr.corp.intel.com> <20150107121340.GB3984@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 7 Jan 2015 07:51:26 -0800
Message-ID: <CALCETrW9N8Dw7r3m=r4rec4GKo18arFgOBxA+WnnLdw+AVb1BQ@mail.gmail.com>
Subject: Re: [PATCH] x86, mce: Get rid of TIF_MCE_NOTIFY and associated mce tricks
To: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 4:13 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Jan 06, 2015 at 06:00:08PM +0000, Luck, Tony wrote:
>> That's fine with me.  Boris ... any comments?
>
> Same here:
>
> Acked-by: Borislav Petkov <bp@suse.de>
>
> I like negative diffstats:
>
>  include/asm/mce.h         |    1
>  include/asm/thread_info.h |    4 -
>  kernel/cpu/mcheck/mce.c   |  109 ++++++++++------------------------------------
>  kernel/signal.c           |    6 --
>  4 files changed, 26 insertions(+), 94 deletions(-)
>
> Procedural question: so this is going in, in the next merge window,
> aimed at 3.20, right?

Yes, assuming that Ingo and Thomas agree.

When does Paul usually send the rcu pull request?  I can send these as
a pull request or an emailed series after that happens.

--Andy

>
> IMO that is a good plan as we have max time to deal with fallout, should
> there be any.
>
> Thanks.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --



-- 
Andy Lutomirski
AMA Capital Management, LLC
