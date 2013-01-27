Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3A0NDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 08:03:06 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42073 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab3A0NDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 08:03:04 -0500
Date: Sun, 27 Jan 2013 14:02:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
Message-ID: <20130127130259.GC3933@gmail.com>
References: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
 <20130127124133.GA3933@gmail.com>
 <20130127125751.GA2369@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130127125751.GA2369@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Sun, Jan 27, 2013 at 01:41:33PM +0100, Ingo Molnar wrote:
> > 
> > * Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> > > hi,
> > > adding sysfs attribute to specify the maximum allowed value
> > > for perf_event_attr::precise_ip field.
> > > 
> > > Adding functionality for simple 'precise' term to get the
> > > maximum allowed value for perf_event_attr::precise_ip field.
> > > 
> > > And finally adding several precise automated tests.
> > 
> > Ok - could we please as a next step turn on cycles:pp as the 
> > default in all the profiling tools (perf record, perf top), 
> > transparently? I.e. if the CPU supports it then use it, if not 
> > then don't complain, just use the highest grade profiling method 
> > available.
> 
> yep, we discussed with Arnaldo this would be good to have

This would be a high-profile, user visible improvement to 
profiling quality.

Thanks,

	Ingo
