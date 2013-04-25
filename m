Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3DYFqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 01:46:08 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44552 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3DYFqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 01:46:06 -0400
X-AuditID: 9c930179-b7b5bae0000069d1-e4-5178c318a55a
From: Namhyung Kim <namhyung@kernel.org>
To: "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/14] perf tools: Introduce new 'ftrace' command
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
	<1366732681.9609.157.camel@gandalf.local.home>
	<87ip3cb7nu.fsf@sejong.aot.lge.com> <5177BEA9.2030207@huawei.com>
Date: Thu, 25 Apr 2013 14:45:59 +0900
In-Reply-To: <5177BEA9.2030207@huawei.com> (zhangwei's message of "Wed, 24 Apr
	2013 19:14:49 +0800")
Message-ID: <87sj2f9n8o.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jovi,

On Wed, 24 Apr 2013 19:14:49 +0800, zhangwei wrote:
> On 2013/4/24 17:27, Namhyung Kim wrote:
>>> Also, have you given thought on how to execute both ftrace and the pmu
>>> counters? That is, to get a way to interleave the data?
>> 
>> I didn't think about it yet.  I just thought enabling event tracing in
>> ftrace and get the data along with the function tracing.  I'm not sure
>> how they interfere each other when enabled at the same time.
>> 
>> If that's not a valid concern, I think it's doable.
>
> There have ftrace:function event in tracing infrastructure, that event works in perf,
> but I'm not sure if it could enhance to showing function graph as this patchset did.
> 	perf record -e ftrace:function ls > /dev/null
> 	perf report

Yes, I know that.

When I asked to Steve that how I can use ftrace:funcgraph_{entry,exit}
as tracepoint events in perf tools, he said it'd be a non-trivial job
and need some amount of scary work. :)

Thanks,
Namhyung
