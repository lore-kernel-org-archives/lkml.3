Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3JBPdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:33:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49201 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3JBPdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:33:15 -0400
Date: Wed, 2 Oct 2013 12:33:07 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] perf timechart segfault
Message-ID: <20131002153307.GL2920@ghostprotocols.net>
References: <CALkWK0k5sQ9WCGevFQ3D18=Fs3ziS8imVVvasE0QR9e0r91cYA@mail.gmail.com>
 <20131002111958.GC10099@krava.brq.redhat.com>
 <CALkWK0mCbnBZXJNFyX3odoGb1pvGs7ox1mOiFacqX98ewBOGKw@mail.gmail.com>
 <20131002115935.GD10099@krava.brq.redhat.com>
 <20131002121346.GA25568@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002121346.GA25568@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 02, 2013 at 02:13:46PM +0200, Ingo Molnar escreveu:
> * Jiri Olsa <jolsa@redhat.com> wrote:
> > On Wed, Oct 02, 2013 at 05:03:48PM +0530, Ramkumar Ramachandra wrote:
> > > Jiri Olsa wrote:
> > > The log of builtin-timechart.c shows that it was last touched by you
> > > three months ago: 5936678 (perf timechart: Remove event types
> > > framework only user, 2013-07-11). Are there some patches awaiting
> > > merge that I'm missing?

> > looks like you're missing this one:
> > (git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core)

> > perf tools: Add default handler for mmap2 events
> > commit e0e3e2d9a522b2230d395922fde9c6ea928ae7f8
> > Author: David Ahern <dsahern@gmail.com>

> > Not sure if this one plus some other MMAP2 David's fixies
> > are on its way up, but if not I guess Arnaldo's planning
> > to push them out eventually ;-)

> Would be nice to get those fixes into perf/urgent ASAP.

Will get a new perf/urgent batch ready today, thanks for pointing those
out.

- Arnaldo
