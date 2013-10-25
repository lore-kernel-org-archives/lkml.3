Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3JYK4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:56:34 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:55351 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab3JYK4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:56:33 -0400
MIME-Version: 1.0
In-Reply-To: <1381468543-25334-7-git-send-email-namhyung@kernel.org>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
	<1381468543-25334-7-git-send-email-namhyung@kernel.org>
Date: Fri, 25 Oct 2013 11:56:31 +0100
Message-ID: <CAFTL4hz-4ASg8iba6A7_wyU8RaT9a7e9oRkobAbz5+qOt9i9RQ@mail.gmail.com>
Subject: Re: [PATCH 6/8] perf tools: Add new comm infrastructure
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/11 Namhyung Kim <namhyung@kernel.org>:
> From: Frederic Weisbecker <fweisbec@gmail.com>
>
> This new comm infrastructure provides two features:
>
> 1) It keeps track of all comms lifecycle for a given thread. This
> way we can associate a timeframe to any thread comm, as long as
> PERF_SAMPLE_TIME samples are joined to comm and fork events.
>
> As a result we should have more precise comm sorted hists with
> seperated entries for pre and post exec time after a fork.
>
> 2) It also makes sure that a given comm string is not duplicated
> but rather shared among the threads that refer to it. This way the
> threads comm can be compared against pointer values from the sort
> infrastructure.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> Link: http://lkml.kernel.org/n/tip-hwjf70b2wve9m2kosxiq8bb3@git.kernel.org
> [ Rename some accessor functions ]
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> [ Fixed up minor const pointer issues and removed 'self' usage ]
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi,

I was wondering about the fate of these patches. I can resend these or
do any rebase if you need to.

Thanks.
