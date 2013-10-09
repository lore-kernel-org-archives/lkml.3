Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3JIRTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:19:15 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:36112 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab3JIRTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:19:11 -0400
Message-ID: <5255900A.5050103@gmail.com>
Date: Wed, 09 Oct 2013 11:19:06 -0600
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
References: <20131009161743.GA3022@quad> <52558278.6080206@gmail.com> <CABPqkBRx1CqwXOjJXWeqEBqkLkZMHWVQJNjv1jjqPakoDNB3Gg@mail.gmail.com> <CABPqkBQKaMd_LuvfUreYb_9hiR-j0BkAyiP2yP-C0TTy+15_fQ@mail.gmail.com>
In-Reply-To: <CABPqkBQKaMd_LuvfUreYb_9hiR-j0BkAyiP2yP-C0TTy+15_fQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/9/13 10:39 AM, Stephane Eranian wrote:
> Looks like the easiest thing to do for perf is to revert:
>
>     Revert "perf tools: Add default handler for mmap2 events"
>     git revert 6adb0b0ae26fcc35cfec068d71f13863faac5b44
>
>     Revert "perf tools: Add attr->mmap2 support"
>     git revert 5c5e854bc760a2e2c878df3cfcf2afa4febcd511
>
> Do you agree?

If you want to strip all of mmap2 you also need 
5654a0257a86c093c2b38ea5d3ceaa17affd735b.

David
