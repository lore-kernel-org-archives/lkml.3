Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaENFKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:10:08 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:65403 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaENFKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:10:05 -0400
Date: Wed, 14 May 2014 07:09:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC net-next] tracing: accelerate tracing filters with BPF
Message-ID: <20140514050958.GB9448@gmail.com>
References: <1400036111-7803-1-git-send-email-ast@plumgrid.com>
 <20140513231708.7eb39a38@gandalf.local.home>
 <CAMEtUuzct=k_9f4QTqRf2TG6mFCjpnfTjo+JkHYQDHKj_i2b+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMEtUuzct=k_9f4QTqRf2TG6mFCjpnfTjo+JkHYQDHKj_i2b+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexei Starovoitov <ast@plumgrid.com> wrote:

> On Tue, May 13, 2014 at 8:17 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Tue, 13 May 2014 19:55:11 -0700
> > Alexei Starovoitov <ast@plumgrid.com> wrote:
> >
> >> Tracing filters are parsing user supplied character string and constructing
> >> a predicate tree. filter_match_preds() was used to walk nodes of the tree to
> >> simulate matching of boolean expression.
> >>
> >
> > I applied this on top of net-next, from:
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
> >  (master branch)
> >
> > and got this compile error:
> 
> Sorry I wasn't clear in the log.
> This patch depends on JIT patches that were posted separately.
> Since this one is RFC, I didn't want to mix them.
> JIT patches:
> http://patchwork.ozlabs.org/patch/348558/
> http://patchwork.ozlabs.org/patch/348559/
> http://patchwork.ozlabs.org/patch/348560/

Might make sense for you to get a korg account and stick such bits 
into Git trees, to ease testing.

Thanks,

	Ingo
