Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab3JKSkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 14:40:43 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44883 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3JKSkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 14:40:41 -0400
Message-ID: <52584626.4050000@gmail.com>
Date: Fri, 11 Oct 2013 12:40:38 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Hugh Dickins <hughd@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] perf: disable mmap2 support
References: <20131009161743.GA3022@quad> <52558278.6080206@gmail.com> <CABPqkBRx1CqwXOjJXWeqEBqkLkZMHWVQJNjv1jjqPakoDNB3Gg@mail.gmail.com> <CABPqkBQKaMd_LuvfUreYb_9hiR-j0BkAyiP2yP-C0TTy+15_fQ@mail.gmail.com> <5255900A.5050103@gmail.com> <CABPqkBQZz=80he07yzagwPjhJBOK-bc_C=hfsK+LjMvcYWZvew@mail.gmail.com>
In-Reply-To: <CABPqkBQZz=80he07yzagwPjhJBOK-bc_C=hfsK+LjMvcYWZvew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane:

On 10/9/13 11:40 AM, Stephane Eranian wrote:
> On Wed, Oct 9, 2013 at 7:19 PM, David Ahern <dsahern@gmail.com> wrote:
>> On 10/9/13 10:39 AM, Stephane Eranian wrote:
>>>
>>> Looks like the easiest thing to do for perf is to revert:
>>>
>>>      Revert "perf tools: Add default handler for mmap2 events"
>>>      git revert 6adb0b0ae26fcc35cfec068d71f13863faac5b44
>>>
>>>      Revert "perf tools: Add attr->mmap2 support"
>>>      git revert 5c5e854bc760a2e2c878df3cfcf2afa4febcd511
>>>
>>> Do you agree?
>>
>>
>> If you want to strip all of mmap2 you also need
>> 5654a0257a86c093c2b38ea5d3ceaa17affd735b.
>>
> You mean:
> commit 384c671e33a7ddf905f2c60b433b9883f0e5a605
> Author: David Ahern <dsahern@gmail.com>
> Date:   Sun Sep 22 19:44:58 2013 -0600
>
>      perf trace: Add mmap2 handler
>

Given that 3.12 rc5 will be out on Sunday and it takes time to go from 
Arnaldo to Ingo to Linus the revert patches should go out today - in 
Arnaldo's next perf/urgent request.

David

