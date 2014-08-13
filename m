Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaHMTXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 15:23:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:48541 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbaHMTXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 15:23:04 -0400
Date: Wed, 13 Aug 2014 16:22:59 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/4] perf tools: API probing fixes
Message-ID: <20140813192259.GE2718@kernel.org>
References: <1407855871-15024-1-git-send-email-adrian.hunter@intel.com>
 <20140813112847.GC2370@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813112847.GC2370@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 13, 2014 at 01:28:47PM +0200, Jiri Olsa escreveu:
> On Tue, Aug 12, 2014 at 06:04:27PM +0300, Adrian Hunter wrote:
> > Hi
> > 
> > Here are some fixes for API probing issues that I have run into,
> > and a second attempt at the jump-label problem.
> > 
> > Patches apply to your tmp.perf/core branch.
> > 
> > 
> > Adrian Hunter (4):
> >       perf tools: Fix CLOEXEC probe for perf_event_paranoid == 2
> >       perf tools: Fix one of the probe events to exclude kernel
> >       perf tools: Fix probing the kernel API with cpu-wide events
> >       perf tools: Prefer to use a cpu-wide event for probing CLOEXEC
> 
> for the patchset:
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied.

- Arnaldo
