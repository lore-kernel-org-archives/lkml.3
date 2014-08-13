Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaHMSlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:41:20 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:62959 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaHMSlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:41:19 -0400
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Gross\, Mark" <mark.gross@intel.com>,
        Paul McKenney <Paul.McKenney@us.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Juri Lelli <juri.lelli@arm.com>, sched-tools@linaro.org
Subject: Re: [ANNOUNCE] Tools to analyse PM and scheduling behaviour
In-Reply-To: <20140813112234.GK9918@twins.programming.kicks-ass.net>
References: <CAP245DUSAHO_VBoBMy4KQaaA6_0a-i3Y3u4utnK8ji3UMVniyA@mail.gmail.com> <20140813112234.GK9918@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 14 Aug 2014 00:11:13 +0530
Message-ID: <8761hwcjw6.fsf@matterhorn.verdurent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Fri, Aug 08, 2014 at 07:24:01PM +0530, Amit Kucheria wrote:
>> Workload Generator Details
>> --------------------------
>> The Workload Generator is based on rt-app. Shared resources, waits, signals
>> and locking order can be specified for each thread in a JSON description to
>> construct complex interdependencies. This allows simulation of interesting
>> use-cases. The repository contains examples of a mp3 and web-browsing
>> workload.
>> 
>> The method to construct the JSON description is quite manual currently. We
>> capture the trace of a workload of interest (say, on Android) and analyse
>> it in kernelshark. We then construct the JSON description by hand until its
>> resultant trace looks similar to the trace from the real workload.
>> 
>> The immediate goal is to expand the library to cover the common mobile
>> workloads. We’re also working with the rt-app maintainer to get our changes
>> merged.
>
> With the end goal of having a program convert a trace into a JSON
> description I take it?

Either that or re-evaluate if perf record and playback can actually do
away with the need to do this.
