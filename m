Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3JYSMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 14:12:39 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:58485 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3JYSMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 14:12:38 -0400
MIME-Version: 1.0
In-Reply-To: <526A8F54.2040601@gmail.com>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
	<1381468543-25334-7-git-send-email-namhyung@kernel.org>
	<CAFTL4hz-4ASg8iba6A7_wyU8RaT9a7e9oRkobAbz5+qOt9i9RQ@mail.gmail.com>
	<20131025130417.GB20423@ghostprotocols.net>
	<526A8F54.2040601@gmail.com>
Date: Fri, 25 Oct 2013 19:12:36 +0100
Message-ID: <CAFTL4hzX=0-_gK6E9V7oH3hrrCerVn_s8TVBsDspzLvpQEmtpw@mail.gmail.com>
Subject: Re: [PATCH 6/8] perf tools: Add new comm infrastructure
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/25 David Ahern <dsahern@gmail.com>:
> On 10/25/13 7:04 AM, Arnaldo Carvalho de Melo wrote:
>>
>> Em Fri, Oct 25, 2013 at 11:56:31AM +0100, Frederic Weisbecker escreveu:
>>>
>>> 2013/10/11 Namhyung Kim <namhyung@kernel.org>:
>>>>
>>>> From: Frederic Weisbecker <fweisbec@gmail.com>
>>
>>
>>>> This new comm infrastructure provides two features:
>>
>>
>>> I was wondering about the fate of these patches. I can resend these or
>>> do any rebase if you need to.
>>
>>
>> So I applied the first few patches, but deferred working on this part,
>> the comm one, because Jiri Olsa had some problems with it, IIRC, Jiri?
>> Can you refresh my mind and ellaborate on it?
>
>
> I also saw some comm related problems with Namhyung's tree. Not sure if it
> contained all of Frederic's patches. I have not had time to chase down what
> is going on -- just that comm's coming out of perf-script were not correct.

Oh I see. It's possible that my massive conversion to use the comm
accessor got blind at some point and left over a few things. I
remember that I only lightly tested that new comm infrastructure. I
mean I tested a lot of "perf report -s foo,bar" combinations for
performance comparisons but I haven't tested the perf script and all
the other perf tools.

I'll rebase these patches and test that wider before resending.

Thanks!
