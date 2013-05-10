Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab3EJJGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:06:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab3EJJGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:06:37 -0400
Date: Fri, 10 May 2013 11:06:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/9] perf tools: Add precise object to interface sysfs
 precise
Message-ID: <20130510090615.GB1040@krava.brq.redhat.com>
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
 <1368106344-23383-3-git-send-email-jolsa@redhat.com>
 <87bo8j7h3a.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo8j7h3a.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 10:34:49AM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Thu,  9 May 2013 15:32:17 +0200, Jiri Olsa wrote:
> > Adding precise util object to get maximum value for
> > perf_event_attr::precise_ip. The value is exported
> > via sysfs file '/sys/devices/cpu/precise'.
> >
> > The interface is:
> >   int perf_precise__get(void)
> 
> I think Arnaldo wants to use double underscores to separate the name of
> data struct and method name.  So wouldn't it be more appropriate using
> one of perf_precise_get() or perf_get_precise()?

hum right, '__' to separate structs methods.. ok, perf_precise_get it is

thanks,
jirka
