Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbbAJKbE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 05:31:04 -0500
Received: from smtprelay.synopsys.com ([198.182.47.9]:59962 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbbAJKbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 05:31:00 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Namhyung Kim <namhyung@kernel.org>
CC: "acme@redhat.com" <acme@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "bp@suse.de" <bp@suse.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "Alexey.Brodkin@synopsys.com" <Alexey.Brodkin@synopsys.com>
Subject: Re: [PATCH 5/5] perf tools: [uclibc] provide stub for
 pthread_attr_setaffinity_np
Thread-Topic: [PATCH 5/5] perf tools: [uclibc] provide stub for
 pthread_attr_setaffinity_np
Thread-Index: AQHQKbge3TD7NQC2/UWZaYAt8kGmRw==
Date: Sat, 10 Jan 2015 10:30:54 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307565BCA76A@IN01WEMBXA.internal.synopsys.com>
References: <1420552335-26886-1-git-send-email-vgupta@synopsys.com>
 <1420552335-26886-6-git-send-email-vgupta@synopsys.com>
 <20150108075653.GG7268@sejong>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,



On Thursday 08 January 2015 01:28 PM, Namhyung Kim wrote:
> On Tue, Jan 06, 2015 at 07:22:15PM +0530, Vineet Gupta wrote:
>> > uClibc Linuxthreads.old doesnt support pthread_attr_setaffinity_np()
>> > call
>> > 
>> > ----------------->8-----------------------
>> >   CC       bench/futex-hash.o
>> >   CC       bench/futex-wake.o
>> > bench/futex-hash.c: In function 'bench_futex_hash':
>> > bench/futex-hash.c:161:3: error: implicit declaration of function
>> > 'pthread_attr_setaffinity_np' [-Werror=implicit-function-declaration]
>> >    ret = pthread_attr_setaffinity_np(&thread_attr, sizeof(cpu_set_t),
>> > &cpu);
>> >    ^
>> > bench/futex-hash.c:161:3: error: nested extern declaration of
>> > 'pthread_attr_setaffinity_np' [-Werror=nested-externs]
>> > ----------------->8-----------------------
>> > 
>> > Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
>> > ---
>> >  tools/perf/bench/futex.h                    | 13 +++++++++++++
>> >  tools/perf/config/Makefile                  |  6 ++++++
>> >  tools/perf/config/feature-checks/Makefile   |  4 ++++
>> >  tools/perf/config/feature-checks/test-all.c |  5 +++++
>> >  4 files changed, 28 insertions(+)
> It seems that you fotgot to add the real test file
> (test-pthread_attr_setaffinity_np.c?) here..

Indeed, apologies for the snafu. I'll include it in v2 for the series.
Any thoughts on rest of patches for the series.
Thanks for the careful review so far.

-Vineet

>
> Thanks,
> Namhyung
>
>

