Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaG2Ol1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:41:27 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61440 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaG2OlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:41:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140728085337.GM6758@twins.programming.kicks-ass.net>
References: <1406277655-21808-1-git-send-email-zheng.z.yan@intel.com>
	<20140728075623.GP19379@twins.programming.kicks-ass.net>
	<53D60459.8040702@intel.com>
	<20140728085337.GM6758@twins.programming.kicks-ass.net>
Date: Tue, 29 Jul 2014 16:41:25 +0200
Message-ID: <CABPqkBQqu9bMMknWhCcw9fqT-vht8FwJoXPjHjvzYf7r7Z0_nA@mail.gmail.com>
Subject: Re: [PATCH] perf/x86/uncore: split Intel uncore driver to smaller files
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 10:53 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jul 28, 2014 at 04:05:45PM +0800, Yan, Zheng wrote:
>> On 07/28/2014 03:56 PM, Peter Zijlstra wrote:
>> > On Fri, Jul 25, 2014 at 04:40:55PM +0800, Yan, Zheng wrote:
>> >> split Intel uncore driver into four files:
>> >>  - perf_event_intel_uncore.c: general functions of Intel uncore driver.
>> >>  - perf_event_intel_uncore_nhmex.c: hardware specific code for
>> >>    Nehalem-EX/Westmere-EX
>> >>  - perf_event_intel_uncore_snb.c: hardware specific code for
>> >>    Nehalem/SandBridge/Haswell
>> >>  - perf_event_intel_uncore_snbep.c: hardware specific code for
>> >>    SandyBridge-EP/IvyTown uncore
>> >
>> > Did not apply properly to tip/master, also can you do that in 3 patches?
>> >
>>
>> the patch is based on tip/perf/core
>
> Hmm, that should be good enough, didn't want to apply though, gave a
> massive rej.
>
>> > One breaking out the nhm/wsm-ex part, one breaking out the
>> > nhm/wsm/snb/ivb/hsw bits, and one for the snb/ivb-ep bits?
>> >
I agree with Peter here.

>> will do
>
> Thanks!
