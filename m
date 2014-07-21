Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479AbaGUSX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:23:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:54112 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933369AbaGUSXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:23:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,702,1400050800"; 
   d="scan'208";a="565070379"
Message-ID: <53CD5AB5.3000307@intel.com>
Date: Mon, 21 Jul 2014 21:23:49 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv3 00/19] perf tools: Factor ordered samples queue
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>	<53CCB6AE.6020505@intel.com> <20140721080219.GA4183@krava.redhat.com>	<53CCD3A7.5070002@intel.com> <20140721095415.GB8865@krava.redhat.com> <87d2cy3c7m.fsf@tassilo.jf.intel.com>
In-Reply-To: <87d2cy3c7m.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/2014 7:31 p.m., Andi Kleen wrote:
> Jiri Olsa <jolsa@redhat.com> writes:
>>
>> [jolsa@ibm-x3650m4-01 perf]$ sudo ./perf report --stdio
>> Timestamp below last timeslice flush
>> 0x2276f58 [0x68]: failed to process type: 9
>
> FWIW we're seeing this frequently too.

Jiri's example didn't work for me.  Do you have one?
