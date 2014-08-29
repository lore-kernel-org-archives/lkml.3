Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaH2SjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:39:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:40565 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbaH2SjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:39:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,425,1406617200"; 
   d="scan'208";a="565512227"
Message-ID: <5400C8C1.50504@intel.com>
Date: Fri, 29 Aug 2014 21:38:57 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/24] perf tools: Add a test for tracking with sched_switch
References: <1408129739-17368-1-git-send-email-adrian.hunter@intel.com> <1408129739-17368-2-git-send-email-adrian.hunter@intel.com> <20140820194813.GI2892@kernel.org> <54008590.7000507@intel.com> <20140829150634.GF3330@kernel.org> <20140829151859.GA11558@krava.brq.redhat.com>
In-Reply-To: <20140829151859.GA11558@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/2014 6:18 p.m., Jiri Olsa wrote:
> On Fri, Aug 29, 2014 at 12:06:34PM -0300, Arnaldo Carvalho de Melo wrote:
>> Em Fri, Aug 29, 2014 at 04:52:16PM +0300, Adrian Hunter escreveu:
>>> On 08/20/2014 10:48 PM, Arnaldo Carvalho de Melo wrote:
>>>> But, for the current architecture, that should be just a clarification,
>>>> not a requirement for this specific test.
>>
>>> I will keep that in mind.
>>
>>>> Applying!
>>
>>> Thank you!
>>
>>> AFAICT the other 20 patches still apply cleanly to your tree, so I am not
>>> going to send any more for now.
>>
>> Ok, I'll try to process more of those, the db interface probably, after
>> I try using it for some simple tests.
>>
>> About the PMU ones, that I would like to hear from other people dealing
>> with that area, like Jiri or even PeterZ, that IIRC discussed sysfs
>> interface aspects in the past, Jiri, Peter?
>
> I reviewed those, but I remember not getting an answer
> for my question about that
>    http://marc.info/?t=140533254600001&r=1&w=2

I guess I didn't understand what you meant.  I will reply to that thread.
