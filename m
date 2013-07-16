Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3GPGP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:15:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:25453 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab3GPGP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:15:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,674,1367996400"; 
   d="scan'208";a="268832652"
Message-ID: <51E4E688.10405@intel.com>
Date: Tue, 16 Jul 2013 09:22:00 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/5] perf: add two new features
References: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com> <20130628152745.GH6626@twins.programming.kicks-ass.net> <51CDE273.9080209@intel.com>
In-Reply-To: <51CDE273.9080209@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/13 22:22, Adrian Hunter wrote:
> On 28/06/2013 6:27 p.m., Peter Zijlstra wrote:
>> On Fri, Jun 28, 2013 at 04:22:16PM +0300, Adrian Hunter wrote:
>>> Hi
>>>
>>> Please consider these two new perf features:
>>>        x86: add ability to calculate TSC from perf sample timestamps
>>>        perf: add 'keep tracking' flag to PERF_EVENT_IOC_DISABLE
>>
>> Please explain to us why you'd like to do this..
> 
> I will see what information I can dig up.  The short answer is that I need
> to disable and re-enable a perf event but still be able to map IPs to their
> DSOs and symbols - which means not losing mmap events.

Any other comments?

