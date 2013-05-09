Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab3EIP1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 11:27:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab3EIP1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 11:27:10 -0400
Date: Thu, 9 May 2013 17:20:22 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/9] perf: Adding better precise_ip field handling
Message-ID: <20130509152022.GD1628@krava.brq.redhat.com>
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
 <20130509150744.GB3039@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509150744.GB3039@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 05:07:44PM +0200, Peter Zijlstra wrote:
> On Thu, May 09, 2013 at 03:32:15PM +0200, Jiri Olsa wrote:
> > hi,
> > adding sysfs attribute to specify the maximum allowed value
> > for perf_event_attr::precise_ip field.
> > 
> > Adding functionality for simple 'p' modifier and 'precise' term
> > to get the maximum allowed value for perf_event_attr::precise_ip
> > field.
> > 
> 
> You've seem to lost the part explaining why we want this.. :-)

well, initially it was an answer when we broke precise event
monitoring in kernel so I wrote automated test for it (patches 1,2,3)
https://lkml.org/lkml/2012/12/12/561

having maximum precise enabled with just single 'p' seemed
like good idea

next step would be to enable precise automatically for 'cycles'
(when PEBS is working) asked for by Ingo
http://marc.info/?l=linux-kernel&m=135929050803963&w=2

jirka
