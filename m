Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3LBMiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:38:13 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:59009 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab3LBMiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:38:12 -0500
Date: Mon, 2 Dec 2013 13:38:08 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 2/2] perf sched: Add documentation for timehist options
Message-ID: <20131202123808.GA22212@gmail.com>
References: <1385943795-11761-1-git-send-email-dsahern@gmail.com>
 <1385943795-11761-3-git-send-email-dsahern@gmail.com>
 <20131202060729.GA28684@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131202060729.GA28684@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> * David Ahern <dsahern@gmail.com> [2013-12-01 17:23:15]:
> 
> > Add entry to perf-sched documentation for timehist command and its
> > options.
> > 
> > v2: Addressed comments by Namhyung
> > 
> > Signed-off-by: David Ahern <dsahern@gmail.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Stephane Eranian <eranian@google.com>
> > Cc: Pekka Enberg <penberg@kernel.org>
> > ---
> >  tools/perf/Documentation/perf-sched.txt | 61 ++++++++++++++++++++++++++++++++-
> >  1 file changed, 60 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/perf/Documentation/perf-sched.txt b/tools/perf/Documentation/perf-sched.txt
> > index 8ff4df956951..e7bb19fcdbff 100644
> > --- a/tools/perf/Documentation/perf-sched.txt
> > +++ b/tools/perf/Documentation/perf-sched.txt
> > @@ -8,7 +8,7 @@ perf-sched - Tool to trace/measure scheduler properties (latencies)
> >  SYNOPSIS
> >  --------
> >  [verse]
> > -'perf sched' {record|latency|map|replay|script}
> > +'perf sched' {record|latency|map|replay|script|timehist}
> >  
> >  DESCRIPTION
> >  -----------
> > @@ -36,6 +36,11 @@ There are five variants of perf sched:
> 
> Nit: There are six variants now.

Trick: it might make sense to use a more future-proof phrase:

		       There are several variants of perf sched:

;-)

Thanks,

	Ingo
