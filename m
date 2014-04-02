Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbaDBHn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:43:28 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:60440 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478AbaDBHn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:43:26 -0400
Date: Wed, 2 Apr 2014 09:43:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>,
        Geoff Levand <geoff@infradead.org>
Subject: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing tool for
 Linux
Message-ID: <20140402074322.GA22744@gmail.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
 <20140331071749.GA1252@gmail.com>
 <CAGdX0WEV5OEfk4vfMKYeEpHP_7XqpUKk2-iwTVoTup1ObYu3eg@mail.gmail.com>
 <CAMEtUuw24=+CkcdwDnJ4AbSCjGBBFx+8pTFzn5gXbQAy=KYWng@mail.gmail.com>
 <CAGdX0WEvsPqWjE8Uade5_i58AepKxGndM0eSg=viB+UYGOSkJw@mail.gmail.com>
 <CAMEtUuxYigBYnH_n_MCrs_=r9KLGOha3rSuNZ876mgH1tAvVCg@mail.gmail.com>
 <CAGdX0WE_xtUY7=CH7Qzxn9Oe8Mz=60wb6izD-APbF5d3caEthA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdX0WE_xtUY7=CH7Qzxn9Oe8Mz=60wb6izD-APbF5d3caEthA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:

> So based on all these input, I suggest:
> 
> Put all these community efforts together, figure out the proper 
> design implementation of dynamic tracing tool, ktap can be a good 
> start to build upon it, evolve to a unified kernel script engine 
> with ebpf together, finally service for dynamic tracing and 
> network(if possible).
> 
> Our goal is same and very clearly, we really want a "simple & 
> flexible & safe" dynamic scripting tracing tool for Linux, which 
> could compare or even better than Dtrace, this is the motivation of 
> ktap project.
> 
> Two solution may be take:
>
> 1). upstream ktap into core trace and evolve it step by step, and 
>     finally make a integrated bytecode engine, it's a long process, 
>     but I think it's worth.
> 
> 2). move ktap back into staging, and graduate from staging after the
>     code make tracing people and ebpf people both happy.
> 
> The benefit is the process will be under the eyes of community.
> 
> Ingo, steven, Greg, what do you think?

For now I'm opting for a third option:

  3) Maintain my NAK on the ktap patches until they address the 
     fundamental design concerns outlined by Alexei and others in 
     their review feedback:

     NAKed-by: Ingo Molnar <mingo@kernel.org>

The thing is, I've outlined some of the concerns in my previous 
review. Not much happened on that front, for example ktap did not get 
any closer in integrating with BPF. Many months have passed since the 
previous ktap submission, still I see no progress on the 'design' 
front. That really needs to change.

Please keep me Cc:-ed to any and all future ktap submissions so I can 
monitor ktap's progress and lift the NAK if the design concerns have 
been addressed.

Thanks,

	Ingo
