Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3AXU6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:58:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab3AXU6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:58:19 -0500
Date: Thu, 24 Jan 2013 17:58:13 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] perf tools: some 'perf script' fixes
Message-ID: <20130124205813.GC14382@infradead.org>
References: <cover.1358527965.git.tom.zanussi@linux.intel.com>
 <20130124182736.GA14382@infradead.org>
 <1359059633.1544.11.camel@empanada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359059633.1544.11.camel@empanada>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 24, 2013 at 02:33:53PM -0600, Tom Zanussi escreveu:
> On Thu, 2013-01-24 at 15:27 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Jan 18, 2013 at 01:51:24PM -0600, Tom Zanussi escreveu:
> > > This patchset fixes various problems I hit while doing a run-through
> > > of the existing 'perf script' scripts.
> > > 
> > > Also, sometimes when running rwtop I get a 'failed to read event
> > > header' error, which this patch fixes:
> > > 
> > > https://lkml.org/lkml/2012/9/14/401
> > > 
> > > Not sure if that was meant to get picked up, but it fixed that
> > > particular problem here for me.
> > 
> > David, can you please resubmit it with an explanation in the commit
> > message?
> > 
> > Tom, can I add a Tested-by: you to such patch?
> > 
> 
> Yeah, sure.
> 
> Tested-by: Tom Zanussi <tom.zanussi@linux.intel.com>

David, perhaps you should just add a local readn variant for 'script'
till we find a more general solution, at least it fixes script's case.

- Arnaldo
 
> Thanks,
> 
> Tom
> 
> > > Tom Zanussi (4):
> > >   perf/tools: reinstate 'signed' field flag for tracepoints
> > >   perf script: don't display trace info when invoking scripts
> > >   perf tools: hook up perf_scripting_context->pevent
> > >   perf script: remove workqueue-stats script
> > 
> > Thanks, applied to my perf/core branch at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux
> > 
> > - Arnaldo
> 
