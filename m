Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105Ab3JOMZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 08:25:05 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:42557 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759074Ab3JOMZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 08:25:03 -0400
MIME-Version: 1.0
In-Reply-To: <52584626.4050000@gmail.com>
References: <20131009161743.GA3022@quad>
	<52558278.6080206@gmail.com>
	<CABPqkBRx1CqwXOjJXWeqEBqkLkZMHWVQJNjv1jjqPakoDNB3Gg@mail.gmail.com>
	<CABPqkBQKaMd_LuvfUreYb_9hiR-j0BkAyiP2yP-C0TTy+15_fQ@mail.gmail.com>
	<5255900A.5050103@gmail.com>
	<CABPqkBQZz=80he07yzagwPjhJBOK-bc_C=hfsK+LjMvcYWZvew@mail.gmail.com>
	<52584626.4050000@gmail.com>
Date: Tue, 15 Oct 2013 14:25:02 +0200
Message-ID: <CABPqkBRX1Qg5s7CKh++gxu4dq+GV0YZp30ixeF9-AmHoec8Gaw@mail.gmail.com>
Subject: Re: [PATCH] perf: disable mmap2 support
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Hugh Dickins <hughd@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

Could you revert all the mmap2 patches in your perf/urgent tree for now?
Thanks.

On Fri, Oct 11, 2013 at 8:40 PM, David Ahern <dsahern@gmail.com> wrote:
> Hi Stephane:
>
>
> On 10/9/13 11:40 AM, Stephane Eranian wrote:
>>
>> On Wed, Oct 9, 2013 at 7:19 PM, David Ahern <dsahern@gmail.com> wrote:
>>>
>>> On 10/9/13 10:39 AM, Stephane Eranian wrote:
>>>>
>>>>
>>>> Looks like the easiest thing to do for perf is to revert:
>>>>
>>>>      Revert "perf tools: Add default handler for mmap2 events"
>>>>      git revert 6adb0b0ae26fcc35cfec068d71f13863faac5b44
>>>>
>>>>      Revert "perf tools: Add attr->mmap2 support"
>>>>      git revert 5c5e854bc760a2e2c878df3cfcf2afa4febcd511
>>>>
>>>> Do you agree?
>>>
>>>
>>>
>>> If you want to strip all of mmap2 you also need
>>> 5654a0257a86c093c2b38ea5d3ceaa17affd735b.
>>>
>> You mean:
>> commit 384c671e33a7ddf905f2c60b433b9883f0e5a605
>> Author: David Ahern <dsahern@gmail.com>
>> Date:   Sun Sep 22 19:44:58 2013 -0600
>>
>>      perf trace: Add mmap2 handler
>>
>
> Given that 3.12 rc5 will be out on Sunday and it takes time to go from
> Arnaldo to Ingo to Linus the revert patches should go out today - in
> Arnaldo's next perf/urgent request.
>
> David
>
