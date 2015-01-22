Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbbAVWnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:43:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:33798 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbbAVWnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:43:19 -0500
Date: Thu, 22 Jan 2015 23:42:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vince Weaver <vince@deater.net>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        X86 ML <x86@kernel.org>
Subject: Re: [PATCH v2 0/8] CR4 handling improvements
In-Reply-To: <CALCETrWMh0G9=vC3A8565y9hKdUYDKsrO6CcsEyVB5ULTv0ZOA@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1501222334390.5526@nanos>
References: <cover.1414190806.git.luto@amacapital.net> <20141031150911.GO23531@worktop.programming.kicks-ass.net> <CALCETrWMh0G9=vC3A8565y9hKdUYDKsrO6CcsEyVB5ULTv0ZOA@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015, Andy Lutomirski wrote:
> On Fri, Oct 31, 2014 at 8:09 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >
> > This looks ok I suppose, although the x86 people should pass verdict on
> > the first few patches.
> 
> Hi all-
> 
> What's the status of this series?

I've reviewed the x86 parts except for the perf stuff. So if Peter is
happy with that he should take it via perf as I expect conflicts there
rather than in the non perf areas

Thanks,

	tglx

