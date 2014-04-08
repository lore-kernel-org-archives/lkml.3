Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbaDHOed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:34:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36584 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbaDHOeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:34:31 -0400
Date: Tue, 8 Apr 2014 11:08:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, Alexei Starovoitov <ast@plumgrid.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>,
        Geoff.Levand@huawei.com
Subject: Re: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing tool
 for Linux
Message-ID: <20140408090836.GN11096@twins.programming.kicks-ass.net>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
 <20140331071749.GA1252@gmail.com>
 <CAGdX0WEV5OEfk4vfMKYeEpHP_7XqpUKk2-iwTVoTup1ObYu3eg@mail.gmail.com>
 <CAMEtUuw24=+CkcdwDnJ4AbSCjGBBFx+8pTFzn5gXbQAy=KYWng@mail.gmail.com>
 <CAGdX0WEvsPqWjE8Uade5_i58AepKxGndM0eSg=viB+UYGOSkJw@mail.gmail.com>
 <CAMEtUuxYigBYnH_n_MCrs_=r9KLGOha3rSuNZ876mgH1tAvVCg@mail.gmail.com>
 <20140402074202.GB22680@gmail.com>
 <20140407135519.GJ10526@twins.programming.kicks-ass.net>
 <5343A7F4.80702@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5343A7F4.80702@hitachi.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 04:40:36PM +0900, Masami Hiramatsu wrote:
> (2014/04/07 22:55), Peter Zijlstra wrote:
> > On Wed, Apr 02, 2014 at 09:42:03AM +0200, Ingo Molnar wrote:
> >> I'd suggest using C syntax instead initially, because that's what the 
> >> kernel is using.
> >>
> >> The overwhelming majority of people probing the kernel are 
> >> programmers, so there's no point in inventing new syntax, we should 
> >> reuse existing syntax!
> > 
> > Yes please, keep it C, I forever forget all other syntaxes. While I have
> > in the past known other languages, I never use them frequently enough to
> > remember them. And there's nothing more frustrating than having to fight
> > a tool/language when you just want to get work done.
> 
> Why wouldn't you write a kernel module in C directly? :)
> It seems that all what you need is not a tracing language nor a bytecode
> engine, but an well organized tracing APIs(library?) for writing a kernel
> module for tracing...

Most my kernels are CONFIG_MODULE=n :-) Also, I never can remember how
to do modules.

That said; what I currently do it hack the kernel with debug bits and
pieces and run that, which is effectively the same. Its just that its
impossible to save/share these hacks in any sane fashion.

