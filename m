Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaIJOCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:02:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17224 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaIJOCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:02:32 -0400
Message-ID: <541059C9.1040200@oracle.com>
Date: Wed, 10 Sep 2014 10:01:45 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu> <20140908185115.GI6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409091203500.14857@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1409091317550.15651@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu> <20140910083136.GP6758@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu>
In-Reply-To: <alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 09:18 AM, Vince Weaver wrote:
> that's what got me looking at things again, the trinity reports.  Though I 
> think those involve CPU hotplugging which my fuzzer shouldn't trigger.
> 
> I do think this is the same memory corruption/reboot bug that I reported 
> back in February (the thread is "perf_fuzzer compiled for x32 causes 
> reboot" but I wasn't able to isolate the problem then either.
> 
> Somehow something is stomping over memory with a forking workload (likely 
> an improper free with RCU like we've seen before) but the fact that it 
> causes a reboot immediately makes it *really* hard to debug this.

Could this be http://permalink.gmane.org/gmane.linux.kernel/1779436 which
I saw couple days ago?


Thanks,
Sasha
