Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3BVJnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:43:45 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:50520 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab3BVJnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:43:40 -0500
Date: Fri, 22 Feb 2013 10:43:36 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Shuah Khan <shuahkhan@gmail.com>, dan.carpenter@oracle.com,
        peterz@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Subject: Re: sched: Fix signedness bug in yield_to()
Message-ID: <20130222094336.GA29235@gmail.com>
References: <20130220022712.0E8586607A4@gitolite.kernel.org>
 <CAKocOOMo-5Hiv_dBCpZNYMP_wXWiWugBYq4qsRcMBwm=TPM=dA@mail.gmail.com>
 <20130221085654.GB23223@gmail.com>
 <20130221232600.GA21754@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130221232600.GA21754@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marcelo Tosatti <mtosatti@redhat.com> wrote:

> On Thu, Feb 21, 2013 at 09:56:54AM +0100, Ingo Molnar wrote:
> > 
> > * Shuah Khan <shuahkhan@gmail.com> wrote:
> > 
> > > On Tue, Feb 19, 2013 at 7:27 PM, Linux Kernel Mailing List
> > > <linux-kernel@vger.kernel.org> wrote:
> > > > Gitweb:     http://git.kernel.org/linus/;a=commit;h=c3c186403c6abd32e719f005f0af950155a9e54d
> > > > Commit:     c3c186403c6abd32e719f005f0af950155a9e54d
> > > > Parent:     e0a79f529d5ba2507486d498b25da40911d95cf6
> > > > Author:     Dan Carpenter <dan.carpenter@oracle.com>
> > > > AuthorDate: Tue Feb 5 14:37:51 2013 +0300
> > > > Committer:  Ingo Molnar <mingo@kernel.org>
> > > > CommitDate: Tue Feb 5 12:59:29 2013 +0100
> > > >
> > > >     sched: Fix signedness bug in yield_to()
> > > >
> > > >     In 7b270f6099 "sched: Bail out of yield_to when source and
> > > >     target runqueue has one task" we changed this to store -ESRCH so
> > > >     it needs to be signed.
> > > 
> > > Dan, Ingo,
> > > 
> > > I can't find the 7b270f6099 "sched: Bail out of yield_to when 
> > > source and target runqueue has one task" in the latest Linus's 
> > > git. Am I missing something.
> > > 
> > > The current kenel/sched/core.c doesn't have the code from the
> > > associated patch https://patchwork.kernel.org/patch/2016651/
> > 
> > As per the lkml discussion that one was supposed to go upstream 
> > via the KVM tree. Marcelo?
> 
> commit c3c186403c6abd32e719f005f0af950155a9e54d
> Author: Dan Carpenter <dan.carpenter@oracle.com>
> Date:   Tue Feb 5 14:37:51 2013 +0300
> 
>     sched: Fix signedness bug in yield_to()

I meant the other patch - the two got disassociated.

Thanks,

	Ingo
