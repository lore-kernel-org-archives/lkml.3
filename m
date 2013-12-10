Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3LJPrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:47:55 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:38117 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab3LJPrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:47:53 -0500
Date: Tue, 10 Dec 2013 16:47:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
Message-ID: <20131210154748.GA1950@gmail.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
 <87fvq9cwlk.fsf@tassilo.jf.intel.com>
 <CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
 <CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
 <20131205104113.GB20283@gmail.com>
 <20131205084657.09b6a2ce@gandalf.local.home>
 <CAMEtUuyp0q9YSMq7OchEeWLz9oPYd3qQ+0SDV5Pt8F10KLbFpg@mail.gmail.com>
 <20131205183735.5f9c8bae@gandalf.local.home>
 <CAMEtUuzkGNbh_ZOd5SbWEdNMz3NEpDZzzAKP=Ov10DKD5hVaKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMEtUuzkGNbh_ZOd5SbWEdNMz3NEpDZzzAKP=Ov10DKD5hVaKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexei Starovoitov <ast@plumgrid.com> wrote:

> > I'm fine if it becomes a requirement to have a vmlinux built with 
> > DEBUG_INFO to use BPF and have a tool like perf to translate the 
> > filters. But it that must not replace what the current filters do 
> > now. That is, it can be an add on, but not a replacement.
> 
> Of course. tracing filters via bpf is an additional tool for kernel 
> debugging. bpf by itself has use cases beyond tracing.

Well, Steve has a point: forcing DEBUG_INFO is a big showstopper for 
most people.

Would it be possible to make BFP filters recognize exposed details 
like the current filters do, without depending on the vmlinux?

Thanks,

	Ingo
