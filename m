Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbaLINdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:33:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757008AbaLINdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:33:51 -0500
Date: Tue, 9 Dec 2014 14:33:33 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: "Liang, Kan" <kan.liang@intel.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>
Subject: Re: [PATCH V5 0/3] perf tool: Haswell LBR call stack support (user)
Message-ID: <20141209133333.GB6784@krava.brq.redhat.com>
References: <20141204142330.GB10406@krava.brq.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F0770167D124@shsmsx102.ccr.corp.intel.com>
 <20141204155142.GD18689@kernel.org>
 <20141204160213.GB18631@krava.brq.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F0770167E1F0@shsmsx102.ccr.corp.intel.com>
 <20141209122708.GA4189@kernel.org>
 <20141209125305.GE2516@krava.brq.redhat.com>
 <20141209131104.GC4189@kernel.org>
 <20141209132206.GA6784@krava.brq.redhat.com>
 <20141209132712.GE4189@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141209132712.GE4189@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 10:27:12AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 09, 2014 at 02:22:06PM +0100, Jiri Olsa escreveu:
> > On Tue, Dec 09, 2014 at 10:11:04AM -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Tue, Dec 09, 2014 at 01:53:05PM +0100, Jiri Olsa escreveu:
> > > > On Tue, Dec 09, 2014 at 09:27:08AM -0300, Arnaldo Carvalho de Melo wrote:
> > > > > Em Thu, Dec 04, 2014 at 04:18:56PM +0000, Liang, Kan escreveu:
> > > > > > > On Thu, Dec 04, 2014 at 12:51:42PM -0300, Arnaldo Carvalho de Melo wrote:
> > > > > > > > Em Thu, Dec 04, 2014 at 02:49:52PM +0000, Liang, Kan escreveu:
> > > > > > > > > Jiri Wrote:
> > > > > > > > > > looks ok to me..
> > > > > > > > > Thanks for the review.
> > > > > > > > > > I'll test it once I get hands on Haswel server again, I guess we
> > > > > > > > > > wait for the kernel change to go in first anyway, right?
> > > > > > > > > I'm not sure, let's ask Peter.
> > > > > > > > > Peter?
> > > > > > > > Would be good to go in one pull request, so that whoever pulls it has
> > > > > > > > the chance to test the kernel feature with the accompanying tooling bits.
> > > > > > > also there's user part dependency on kernel.. soem new define IIRC
> > > > > > Oh, right. We have to let them go in together.
> > > > > The ones that are just prep patches I am merging now, Jiri, can I stick
> > > > > an Acked-by to the non-LBR related ones?
> > >  
> > > > I guess u mean just this one? 
> > > > 2803   T Dec 02 kan.liang@intel (3.4K) ├─>[PATCH V5 2/3] perf tool: Move cpumode resolve code to add_callchain_ip
> > > 
> > > There is another I split from, iirc 1/3, that is unrelated to that
> > > patch, fixing '-g fp' usage that became invalid after a patch from you:
> > > 
> > > https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/commit/?h=perf/core&id=f70b4e39de4ef25aade966c0dfc69cfb97091be9
> > 
> > this onliner is ok, but I dont recall seeing this change separated..
> 
> I did the separation here, I thought I could have your ack there as you
> said you was ok with the whole patchkit, no?
>  
> > and its 'Link' points to the whole 1/3 patch, which seems weird
> > 
> > what do I miss?
> 
> Well, that is why I added the comment just before my S-o-B :-) We could
> have gone thru the whole process of me submitting a patchkit so that we
> could have a proper Link:, but I thought it was too straightforward to
> warrant that :-\

ah ok.. u can keep the ack on the onliner of course

jirka
