Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab3AXUeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:34:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:48712 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618Ab3AXUdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:33:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,532,1355126400"; 
   d="scan'208";a="251973987"
Message-ID: <1359059633.1544.11.camel@empanada>
Subject: Re: [PATCH 0/4] perf tools: some 'perf script' fixes
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 24 Jan 2013 14:33:53 -0600
In-Reply-To: <20130124182736.GA14382@infradead.org>
References: <cover.1358527965.git.tom.zanussi@linux.intel.com>
	 <20130124182736.GA14382@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 15:27 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jan 18, 2013 at 01:51:24PM -0600, Tom Zanussi escreveu:
> > This patchset fixes various problems I hit while doing a run-through
> > of the existing 'perf script' scripts.
> > 
> > Also, sometimes when running rwtop I get a 'failed to read event
> > header' error, which this patch fixes:
> > 
> > https://lkml.org/lkml/2012/9/14/401
> > 
> > Not sure if that was meant to get picked up, but it fixed that
> > particular problem here for me.
> 
> David, can you please resubmit it with an explanation in the commit
> message?
> 
> Tom, can I add a Tested-by: you to such patch?
> 

Yeah, sure.

Tested-by: Tom Zanussi <tom.zanussi@linux.intel.com>

Thanks,

Tom

> > Tom Zanussi (4):
> >   perf/tools: reinstate 'signed' field flag for tracepoints
> >   perf script: don't display trace info when invoking scripts
> >   perf tools: hook up perf_scripting_context->pevent
> >   perf script: remove workqueue-stats script
> 
> Thanks, applied to my perf/core branch at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux
> 
> - Arnaldo


