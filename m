Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3F1TWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:22:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:48713 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab3F1TWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:22:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,961,1363158000"; 
   d="scan'208";a="337184581"
Message-ID: <51CDE273.9080209@intel.com>
Date: Fri, 28 Jun 2013 22:22:27 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/5] perf: add two new features
References: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com> <20130628152745.GH6626@twins.programming.kicks-ass.net>
In-Reply-To: <20130628152745.GH6626@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/2013 6:27 p.m., Peter Zijlstra wrote:
> On Fri, Jun 28, 2013 at 04:22:16PM +0300, Adrian Hunter wrote:
>> Hi
>>
>> Please consider these two new perf features:
>>        x86: add ability to calculate TSC from perf sample timestamps
>>        perf: add 'keep tracking' flag to PERF_EVENT_IOC_DISABLE
>
> Please explain to us why you'd like to do this..

I will see what information I can dig up.  The short answer is that I 
need to disable and re-enable a perf event but still be able to map IPs 
to their DSOs and symbols - which means not losing mmap events.
