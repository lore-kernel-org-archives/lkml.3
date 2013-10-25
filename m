Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3JYPdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:33:45 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43779 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3JYPdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:33:44 -0400
Message-ID: <526A8F54.2040601@gmail.com>
Date: Fri, 25 Oct 2013 09:33:40 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf tools: Add new comm infrastructure
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org> <1381468543-25334-7-git-send-email-namhyung@kernel.org> <CAFTL4hz-4ASg8iba6A7_wyU8RaT9a7e9oRkobAbz5+qOt9i9RQ@mail.gmail.com> <20131025130417.GB20423@ghostprotocols.net>
In-Reply-To: <20131025130417.GB20423@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/13 7:04 AM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Oct 25, 2013 at 11:56:31AM +0100, Frederic Weisbecker escreveu:
>> 2013/10/11 Namhyung Kim <namhyung@kernel.org>:
>>> From: Frederic Weisbecker <fweisbec@gmail.com>
>
>>> This new comm infrastructure provides two features:
>
>> I was wondering about the fate of these patches. I can resend these or
>> do any rebase if you need to.
>
> So I applied the first few patches, but deferred working on this part,
> the comm one, because Jiri Olsa had some problems with it, IIRC, Jiri?
> Can you refresh my mind and ellaborate on it?

I also saw some comm related problems with Namhyung's tree. Not sure if 
it contained all of Frederic's patches. I have not had time to chase 
down what is going on -- just that comm's coming out of perf-script were 
not correct.

David

