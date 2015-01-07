Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbbAGMNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 07:13:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46890 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbbAGMNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:13:44 -0500
Date: Wed, 7 Jan 2015 13:13:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] x86, mce: Get rid of TIF_MCE_NOTIFY and associated mce
 tricks
Message-ID: <20150107121340.GB3984@pd.tnic>
References: <CALCETrV6=aWoAckieQkPJ4BCr9VzU=9080EmLfeL4ZWm+Hr55g@mail.gmail.com>
 <54ab2ffa301102cd6e@agluck-desk.sc.intel.com>
 <CALCETrV+mchcQ5SgBO8+xLvw9rrHm4yvq+wZtQsD1EMMGzAMEw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3299127A@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3299127A@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 06:00:08PM +0000, Luck, Tony wrote:
> That's fine with me.  Boris ... any comments?

Same here:

Acked-by: Borislav Petkov <bp@suse.de>

I like negative diffstats:

 include/asm/mce.h         |    1
 include/asm/thread_info.h |    4 -
 kernel/cpu/mcheck/mce.c   |  109 ++++++++++------------------------------------
 kernel/signal.c           |    6 --
 4 files changed, 26 insertions(+), 94 deletions(-)

Procedural question: so this is going in, in the next merge window,
aimed at 3.20, right?

IMO that is a good plan as we have max time to deal with fallout, should
there be any.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
