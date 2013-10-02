Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3JBQOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:14:47 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41550 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3JBQOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:14:46 -0400
Date: Wed, 2 Oct 2013 13:14:36 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [BUG] perf tests: Test converting perf time to TSC
Message-ID: <20131002161436.GN2920@ghostprotocols.net>
References: <20131002132308.GB20396@krava.brq.redhat.com>
 <524C23D3.6020300@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524C23D3.6020300@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 02, 2013 at 04:46:59PM +0300, Adrian Hunter escreveu:
> On 02/10/13 16:23, Jiri Olsa wrote:
> > hi,
> > got a segfault in the tsc test on latest acme's tree.
> > 
> > I'm dealing with some other issues right now, so just reporting ;-)
> 
> The capability bits have changed positions.  You need to have:
> 
> commit fa7315871046b9a4c48627905691dbde57e51033
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Thu Sep 19 10:16:42 2013 +0200
> 
>     perf: Fix capabilities bitfield compatibility in 'struct
> perf_event_mmap_page'
> 
> in both (or neither) of your kernel and perf tools.

Yeah, I'll merge perf/urgent into acme/perf/core soon.

- Arnaldo
