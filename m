Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbbAWIh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:37:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:45662 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbbAWIhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:37:24 -0500
Date: Fri, 23 Jan 2015 09:37:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vince Weaver <vince@deater.net>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        X86 ML <x86@kernel.org>
Subject: Re: [PATCH v2 0/8] CR4 handling improvements
Message-ID: <20150123083717.GC2896@worktop.programming.kicks-ass.net>
References: <cover.1414190806.git.luto@amacapital.net>
 <20141031150911.GO23531@worktop.programming.kicks-ass.net>
 <CALCETrWMh0G9=vC3A8565y9hKdUYDKsrO6CcsEyVB5ULTv0ZOA@mail.gmail.com>
 <alpine.DEB.2.11.1501222334390.5526@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501222334390.5526@nanos>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 11:42:49PM +0100, Thomas Gleixner wrote:
> On Tue, 13 Jan 2015, Andy Lutomirski wrote:
> > On Fri, Oct 31, 2014 at 8:09 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > >
> > > This looks ok I suppose, although the x86 people should pass verdict on
> > > the first few patches.
> > 
> > Hi all-
> > 
> > What's the status of this series?
> 
> I've reviewed the x86 parts except for the perf stuff. So if Peter is
> happy with that he should take it via perf as I expect conflicts there
> rather than in the non perf areas

Ah indeed you did; let me queue the lot then. Thanks!
