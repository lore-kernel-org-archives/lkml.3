Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaGLFdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 01:33:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:63530 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbaGLFdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 01:33:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,647,1400050800"; 
   d="scan'208";a="560813312"
Message-ID: <53C0C8A8.6020102@intel.com>
Date: Sat, 12 Jul 2014 08:33:28 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: acme@kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        "Shishkin, Alexander" <alexander.shishkin@intel.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: perf tools: Call graph from Intel BTS
References: <53BFF679.2030006@intel.com> <20140711153626.GP20603@laptop.programming.kicks-ass.net>
In-Reply-To: <20140711153626.GP20603@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 6:36 p.m., Peter Zijlstra wrote:
> On Fri, Jul 11, 2014 at 05:36:41PM +0300, Adrian Hunter wrote:
>> Alexander Shishkin is working on the Intel PT driver for perf
>> and has included a driver for Intel BTS.  I have taken that and
>
> There is already a BTS driver, although I've not used it ever, since
> there's no useful tool for it. One way would be to use that, and migrate
> to PT data later.

Currently that driver does not allow kernel tracing.  Last time I tried it
with that restriction removed, it would lose data on larger workloads.
Generally, any loss of data ruins the call graph.

For me it does not make sense to try to support it, since I am primarily
trying to pave the way for the Intel PT driver.
