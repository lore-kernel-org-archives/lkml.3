Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3A0M6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 07:58:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab3A0M6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 07:58:11 -0500
Date: Sun, 27 Jan 2013 13:57:51 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
Message-ID: <20130127125751.GA2369@krava.brq.redhat.com>
References: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
 <20130127124133.GA3933@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130127124133.GA3933@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 01:41:33PM +0100, Ingo Molnar wrote:
> 
> * Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > hi,
> > adding sysfs attribute to specify the maximum allowed value
> > for perf_event_attr::precise_ip field.
> > 
> > Adding functionality for simple 'precise' term to get the
> > maximum allowed value for perf_event_attr::precise_ip field.
> > 
> > And finally adding several precise automated tests.
> 
> Ok - could we please as a next step turn on cycles:pp as the 
> default in all the profiling tools (perf record, perf top), 
> transparently? I.e. if the CPU supports it then use it, if not 
> then don't complain, just use the highest grade profiling method 
> available.

yep, we discussed with Arnaldo this would be good to have

jirka
