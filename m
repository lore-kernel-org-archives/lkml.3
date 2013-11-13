Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab3KMAGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 19:06:43 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:59274 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035Ab3KMAGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 19:06:37 -0500
Date: Wed, 13 Nov 2013 01:06:33 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] panic: improve panic_timeout calculation
Message-ID: <20131113000633.GB2420@gmail.com>
References: <1383871600-3831-3-git-send-email-felipe.contreras@gmail.com>
 <20131111113218.GF15810@gmail.com>
 <CAMP44s0AVy=ef1k95bXsRJizW6zsPApFe9KPrRcg09ORo=2mQA@mail.gmail.com>
 <20131111124953.GA6765@gmail.com>
 <CAMP44s07Ub=G5mD_zkMvPkwcPWm6psZ-8L32dScy1txQkU_9Nw@mail.gmail.com>
 <20131111132812.GB7258@gmail.com>
 <CAMP44s2NYKfrYngTEN5+mPPHOJZLNmSVd3n8k5QNv_=Lpvncsw@mail.gmail.com>
 <20131111135216.GB8781@gmail.com>
 <20131111153206.GA22113@thunk.org>
 <CAMP44s0qsjc_hHedYGt9tB=v8_UArM4N+vnwNybZ39vaoRXytA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s0qsjc_hHedYGt9tB=v8_UArM4N+vnwNybZ39vaoRXytA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Felipe Contreras <felipe.contreras@gmail.com> wrote:

> On Mon, Nov 11, 2013 at 9:32 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Mon, Nov 11, 2013 at 02:52:16PM +0100, Ingo Molnar wrote:
> >> > That's exactly what I did. Addressing feedback constructively doesn't
> >> > mean do exactly what you say without arguing.
> >>
> >> Your reply to my routine feedback was obtuse, argumentative and needlessly
> >> confrontative - that's not 'constructive'.
> >
> > Felipe, remember when on the Git list Junio said he would stop trying
> > to respond to any patches that had problems because you couldn't
> > respond constructively to feedback, and you claimed that you had no
> > problems working with other folks, including on the Linux Kernel
> > mailing list?
> 
> Ingo Molnar != kernel folks, and I don't see any hints of kernel folks 
> suggesting to drop patch #1 because of non-technical issues.
> 
> If the patch is technically correct, conforms to standard practices, and 
> solves a problem; it gets applied. Isn't that how it works in Linux?

I simply described to you what is standing Linux kernel maintenance 
policy.

It is not new nor unusual that kernel patch changelog quality matters: 
defective changelogs are routinely pointed out during review and are 
required to be fixed before a patch can progress. Linux kernel maintainers 
frequently push back against deficient changelogs - in fact they are 
expected to push back against them.

Your claim that a changelog defect that got pointed out during review is a 
'non-technical', 'administrative' problem in Linux kernel development is 
simply wrong and your continued stubborn refusal to address such review 
feedback constructively is unnecessarily complicating the efficient 
processing of these patches.

Thanks,

	Ingo
