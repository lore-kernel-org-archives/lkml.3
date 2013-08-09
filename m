Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab3HISQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:16:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:41505 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758595Ab3HISQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:16:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,847,1367996400"; 
   d="scan'208";a="344149959"
Message-ID: <520531EA.5040309@intel.com>
Date: Fri, 09 Aug 2013 21:16:10 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V10 00/13] perf tools: some fixes and tweaks
References: <1376045519-13832-1-git-send-email-adrian.hunter@intel.com> <CABPqkBSia0kzALAeFKVZ--zC13e=L5UZExP=oTTBuKQxXUAqkA@mail.gmail.com> <5204F5D9.2070703@intel.com> <CABPqkBRp8L=3vM0CjDLOXt0EKHKzSuDbjLQm8pWJC+vVqgbGjw@mail.gmail.com>
In-Reply-To: <CABPqkBRp8L=3vM0CjDLOXt0EKHKzSuDbjLQm8pWJC+vVqgbGjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/08/2013 4:58 p.m., Stephane Eranian wrote:
> On Fri, Aug 9, 2013 at 3:59 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
>> On 09/08/13 16:41, Stephane Eranian wrote:
>>> Adrian,
>>>
>>> Is there a git tree where I could pull those patches from?
>>
>> I plonked it down here for you:
>>
>>          http://git.infradead.org/users/ahunter/linux-perf.git

That was just a gitweb link sorry.

>>
> fatal: http://git.infradead.org/users/ahunter/linux-perf.git/info/refs
> not found: did you run git update-server-info on the server?

Try:

	git://git.infradead.org/users/ahunter/linux-perf.git

Also, it is still on v3.11-rc1 which has scsi regressions, so merge with 
v3.11-rc4 if you want something that will actually boot.

>
>>> That would avoid me pulling them down from my gmail
>>> inbox one by one.
>>>
>>> I am interested in the PERF_SAMPLE_IDENTIFIER support.
>>> And I want to test it.

