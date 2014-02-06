Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbaBFN6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 08:58:06 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:44537 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbaBFN6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:58:02 -0500
MIME-Version: 1.0
In-Reply-To: <20140206135627.GA26955@infradead.org>
References: <CABPqkBSkSbWvdRu3iEtNvHhfV4J4sALHvdd40hZTcGxLe576yQ@mail.gmail.com>
	<20140206135627.GA26955@infradead.org>
Date: Thu, 6 Feb 2014 14:58:01 +0100
Message-ID: <CABPqkBS5qLDYyyv=n8fT4K+hA3uRWYmQOZmO+n-UE9=X=cEFzQ@mail.gmail.com>
Subject: Re: [BUG] perf top: --stdio causes continuous refresh
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 2:56 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Wed, Feb 05, 2014 at 10:25:09PM +0100, Stephane Eranian escreveu:
>> If you run perf top on 3.14 but you force --stdio mode, perf top
>> goes crazy and constantly refreshes the output.
>>
>> It does that with many older versions of the perf as well on 3.14.
>> It runs fine with newt mode.
>>
>> Works fine with my 3.11 kernel. So something must be broken
>> with 3.14.
>
>> Can you reproduce the problem as well?
>
> Not so far, using my perf/urgent branch:
>
I am using tip.git. Or try 3.11, 3.10.


> [root@ssdandy ~]# perf --version
> perf version 3.13.g1da187
>
> Also it honours --delay, i.e.
>
> # perf top --delay 5 --stdio
>
> it will wait 5 seconds between refreshes, etc.
>
> Checking out v3.14-rc1 now.
>
> - Arnaldo
