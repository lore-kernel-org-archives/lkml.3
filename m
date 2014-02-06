Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaBFOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:09:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbaBFOJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:09:56 -0500
Date: Thu, 6 Feb 2014 12:09:36 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [BUG] perf top: --stdio causes continuous refresh
Message-ID: <20140206140936.GC26955@infradead.org>
References: <CABPqkBSkSbWvdRu3iEtNvHhfV4J4sALHvdd40hZTcGxLe576yQ@mail.gmail.com>
 <20140206135627.GA26955@infradead.org>
 <CABPqkBS5qLDYyyv=n8fT4K+hA3uRWYmQOZmO+n-UE9=X=cEFzQ@mail.gmail.com>
 <20140206140705.GB26955@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206140705.GB26955@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 06, 2014 at 12:07:05PM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Feb 06, 2014 at 02:58:01PM +0100, Stephane Eranian escreveu:
> > On Thu, Feb 6, 2014 at 2:56 PM, Arnaldo Carvalho de Melo
> > <acme@redhat.com> wrote:
> > > Em Wed, Feb 05, 2014 at 10:25:09PM +0100, Stephane Eranian escreveu:
> > >> If you run perf top on 3.14 but you force --stdio mode, perf top
> > >> goes crazy and constantly refreshes the output.
> 
> > >> It does that with many older versions of the perf as well on 3.14.
> > >> It runs fine with newt mode.
> 
> > >> Works fine with my 3.11 kernel. So something must be broken
> > >> with 3.14.
> 
> > >> Can you reproduce the problem as well?
> 
> > > Not so far, using my perf/urgent branch:
> 
> > I am using tip.git. Or try 3.11, 3.10.

But my tests are on top of:

[acme@ssdandy linux]$ uname -r
3.11.4-101.fc18.x86_64

I thought it was a 3.14ish one, building one to try there...

- Arnaldo
