Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbaE3JsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:48:04 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:33202 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbaE3JsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:48:01 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFx+j4104ZFmA-YnDtyfmV4FuejwmGnD5shfY0WX4fN+Kg@mail.gmail.com>
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>
	<1401260039-18189-2-git-send-email-minchan@kernel.org>
	<CA+55aFxXdc22dirnE49UbQP_2s2vLQpjQFL+NptuyK7Xry6c=g@mail.gmail.com>
	<20140528223142.GO8554@dastard>
	<CA+55aFyRk6_v6COPGVvu6hvt=i2A8-dPcs1X3Ydn1g24AxbPkg@mail.gmail.com>
	<20140529013007.GF6677@dastard>
	<CA+55aFzdq2V-Q3WUV7hQJG8jBSAvBqdYLVTNtbD4ObVZ5yDRmw@mail.gmail.com>
	<20140529072633.GH6677@dastard>
	<CA+55aFx+j4104ZFmA-YnDtyfmV4FuejwmGnD5shfY0WX4fN+Kg@mail.gmail.com>
Date: Fri, 30 May 2014 11:48:00 +0200
Message-ID: <CAFLxGvwJV+PJchoNEJjnge9CuBrxFJ3TPxcN_M+j1CdAW-GmNA@mail.gmail.com>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Minchan Kim <minchan@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 5:24 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> So I'm not in fact arguing against Minchan's patch of upping
> THREAD_SIZE_ORDER to 2 on x86-64, but at the same time stack size does
> remain one of my "we really need to be careful" issues, so while I am
> basically planning on applying that patch, I _also_ want to make sure
> that we fix the problems we do see and not just paper them over.
>
> The 8kB stack has been somewhat restrictive and painful for a while,
> and I'm ok with admitting that it is just getting _too_ damn painful,
> but I don't want to just give up entirely when we have a known deep
> stack case.

If we raise the stack size on x86_64 to 16k, what about i386?
Beside of the fact that most of you consider 32bits as dead and must die... ;)

-- 
Thanks,
//richard
