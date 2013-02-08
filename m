Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153Ab3BHOSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:18:47 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:41597 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760076Ab3BHOSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:18:46 -0500
Date: Fri, 8 Feb 2013 15:18:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] scheduler include file reorganization
Message-ID: <20130208141841.GB30334@gmail.com>
References: <20130207094650.76302f47@riff.lan>
 <20130207185608.GA25223@gmail.com>
 <20130207191345.GA28960@gmail.com>
 <20130207195257.GA29985@gmail.com>
 <20130207150838.02226207@riff.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130207150838.02226207@riff.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Clark Williams <williams@redhat.com> wrote:

> On Thu, 7 Feb 2013 20:52:57 +0100
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Ingo Molnar <mingo@kernel.org> wrote:
> > 
> > > 
> > > * Ingo Molnar <mingo@kernel.org> wrote:
> > > 
> > > > Yeah, that looks pretty good.
> > > > 
> > > > I'll give it some testing.
> > > 
> > > Found one build error so far, applied the fix below.
> > 
> > Another one was in NOMMU mode (fixed below) - a hidden sched.h 
> > include file dependency in mm/nommu.c.
> > 
> > It's looking good otherwise!
> > 
> > Thanks,
> > 
> > 	Ingo
> >
> 
> Huh, I did a build with an allmodconfig config file. You must 
> be doing some odd permutations.

Yeah, randconfig coverage and cross-arch build coverage. One of 
the build errors triggered on allnoconfig, the other on the 
blackfin architecture.

> I have both of your fixes applied, send me any more you find 
> and I'll regenerate.

No need, I fixed your series locally and pushed out the result.

Wanna split out some other parts of sched.h? ;-) I can do the 
build coverage testing part for those as well.

Thanks,

	Ingo
