Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbbAGP63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:58:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43275 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbbAGP6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:58:10 -0500
Date: Wed, 7 Jan 2015 16:58:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] x86, mce: Get rid of TIF_MCE_NOTIFY and associated mce
 tricks
Message-ID: <20150107155805.GF3984@pd.tnic>
References: <CALCETrV6=aWoAckieQkPJ4BCr9VzU=9080EmLfeL4ZWm+Hr55g@mail.gmail.com>
 <54ab2ffa301102cd6e@agluck-desk.sc.intel.com>
 <CALCETrV+mchcQ5SgBO8+xLvw9rrHm4yvq+wZtQsD1EMMGzAMEw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3299127A@ORSMSX114.amr.corp.intel.com>
 <20150107121340.GB3984@pd.tnic>
 <CALCETrW9N8Dw7r3m=r4rec4GKo18arFgOBxA+WnnLdw+AVb1BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrW9N8Dw7r3m=r4rec4GKo18arFgOBxA+WnnLdw+AVb1BQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 07:51:26AM -0800, Andy Lutomirski wrote:
> When does Paul usually send the rcu pull request?  I can send these as
> a pull request or an emailed series after that happens.

I'd put a note in the pull request for tip guys to pull after Paul's
pull req., for example.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
