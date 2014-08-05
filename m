Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbaHEROU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 13:14:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:6530 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbaHEROS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 13:14:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="368283378"
Message-ID: <53E110A9.6020204@intel.com>
Date: Tue, 05 Aug 2014 20:13:13 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 00/31] perf tools: Yet more preparation for call graph
 from Intel BTS
References: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com> <20140804215816.GG13375@kernel.org>
In-Reply-To: <20140804215816.GG13375@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/08/2014 12:58 a.m., Arnaldo Carvalho de Melo wrote:
> Em Thu, Jul 31, 2014 at 09:00:43AM +0300, Adrian Hunter escreveu:
>> Hi
>>
>> Here is the next selection of patches based on tip/perf/core.
>>
>> They can also be found here:
>>
>> 	http://git.infradead.org/users/ahunter/linux-perf.git/shortlog/refs/heads/for-acme
>
> Just FYI, did some processing today, what I picked I stashed on my
> tmp.perf/core branch, will continue.

Thank you!

>
> But having something that actually uses all this stuff in 'perf test' is
> something I'm missing...
>
> Things like using that set_tracking new API on a evlist with the
> sched_switch, using it to track, then switching it off after moving the
> tracking event to another event in the list, etc.

I will look at that.
