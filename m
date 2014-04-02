Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbaDBRdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:33:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:16069 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387AbaDBRcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:32:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,780,1389772800"; 
   d="scan'208";a="513460279"
Message-ID: <533C4474.2060608@linux.intel.com>
Date: Wed, 02 Apr 2014 10:10:12 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <ak@linux.intel.com>, Gleb Natapov <gleb@redhat.com>,
        Peter Anvin <hpa@zytor.com>, Jan Hubicka <hubicka@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
References: <201403312105.s2VL5AqX010173@terminus.zytor.com>	<CA+55aFwccMZNgHA_xS_+cLNPqEjAt4qm2LYK_WLU0XbeDOoa=g@mail.gmail.com>	<20140331230347.GH32556@tassilo.jf.intel.com>	<CA+55aFyOPkCO7Cpf7pG1wD3QL0CVwKrcf+zKVka51ROABFGn-w@mail.gmail.com>	<CA+55aFxCCOASxhgRfGmNRPgHwZQJ2Q0Oa9-vwpMdmTqx99m26g@mail.gmail.com>	<533B0B5F.2040907@linux.intel.com>	<20140401200145.05e0437e@gandalf.local.home>	<CA+55aFyQHdtgQpnS7ar2db5QoZhmMStH_LgxHvAaCUbVEx_PQQ@mail.gmail.com> <20140402083325.2b6e5d8b@gandalf.local.home>
In-Reply-To: <20140402083325.2b6e5d8b@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 05:33 AM, Steven Rostedt wrote:
> On Tue, 1 Apr 2014 17:35:05 -0700
> 
> Heh, I know that not having the SYSCALL_DEFINEx() wrappers means that
> they wont be traced. I must have misunderstood Peter, as I thought he
> meant if we added SYSCALL_DEFINEx(), that they would break tracing.
> 

No, I meant that them being missing breaks tracing.

> 
> Yeah, adding the SYSCALL_DEFINEx() macros around those functions would
> be good for tracing as well.
> 
> Glad I understand you two now ;-)
> 

:)

Do you want to do the patch?

	-hpa


