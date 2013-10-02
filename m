Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3JBMNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:13:55 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:45721 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3JBMNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:13:52 -0400
Date: Wed, 2 Oct 2013 14:13:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [BUG] perf timechart segfault
Message-ID: <20131002121346.GA25568@gmail.com>
References: <CALkWK0k5sQ9WCGevFQ3D18=Fs3ziS8imVVvasE0QR9e0r91cYA@mail.gmail.com>
 <20131002111958.GC10099@krava.brq.redhat.com>
 <CALkWK0mCbnBZXJNFyX3odoGb1pvGs7ox1mOiFacqX98ewBOGKw@mail.gmail.com>
 <20131002115935.GD10099@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002115935.GD10099@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Wed, Oct 02, 2013 at 05:03:48PM +0530, Ramkumar Ramachandra wrote:
> > Hi Jiri,
> > 
> > Jiri Olsa wrote:
> > > what perf version are you running?
> > 
> > I'm running off the one in torvalds/linux.git.
> > 
> > $ perf --version
> > perf version 3.12.rc3.g34b22d5
> > 
> > The log of builtin-timechart.c shows that it was last touched by you
> > three months ago: 5936678 (perf timechart: Remove event types
> > framework only user, 2013-07-11). Are there some patches awaiting
> > merge that I'm missing?
> 
> looks like you're missing this one:
> (git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core)
> 
> perf tools: Add default handler for mmap2 events
> commit e0e3e2d9a522b2230d395922fde9c6ea928ae7f8
> Author: David Ahern <dsahern@gmail.com>
> Date:   Sun Sep 22 19:44:59 2013 -0600
> 
> Not sure if this one plus some other MMAP2 David's fixies
> are on its way up, but if not I guess Arnaldo's planning
> to push them out eventually ;-)

Would be nice to get those fixes into perf/urgent ASAP.

Thanks,

	Ingo
