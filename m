Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3JCJrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:47:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:15782 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab3JCJrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:47:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1024,1371106800"; 
   d="scan'208";a="410872795"
Message-ID: <524D3ED8.2030109@intel.com>
Date: Thu, 03 Oct 2013 12:54:32 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [BUG] perf tests: Test converting perf time to TSC
References: <20131002132308.GB20396@krava.brq.redhat.com> <524C23D3.6020300@intel.com> <20131003081737.GB993@krava.brq.redhat.com> <524D2E06.5020801@intel.com> <20131003085625.GA3081@twins.programming.kicks-ass.net> <20131003085807.GO26785@twins.programming.kicks-ass.net>
In-Reply-To: <20131003085807.GO26785@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/13 11:58, Peter Zijlstra wrote:
> On Thu, Oct 03, 2013 at 10:56:25AM +0200, Peter Zijlstra wrote:
>>> No the ABI is broken in that case - better to crash.
>>
>> No; neither case should crash.
> 
> OK; previously we would report cap_usr_time = 1 even though we might not
> have written stuff into the fields; which would indeed explain the
> crash.
> 
> However; Jiri actually has the patch; as the code he posted had 'user' not
> 'usr'

Where do you see that?

