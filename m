Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab3K1Rhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:37:52 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:56761 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758916Ab3K1Rhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:37:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvykU+KZg9q1pq68_p+2gfg+5auABX34df88qAF9v0vzMw@mail.gmail.com>
References: <CA+a=Yy60b7nCjsXfczpOebbG27kJNoa9hPcdMHLJrN7qT5mfdg@mail.gmail.com>
 <CAMuHMdVS-EU0y+yLzdM=H20j7ewHKc_DAWFNL4Y1WE9_iNWVLA@mail.gmail.com>
 <CA+a=Yy5Q=urtPfLEcu0WDJngo_COOZGnBuuVkkwUezKfcoGEwA@mail.gmail.com> <CAFLxGvykU+KZg9q1pq68_p+2gfg+5auABX34df88qAF9v0vzMw@mail.gmail.com>
From: Peng Tao <lkml.bergwolf@gmail.com>
Date: Fri, 29 Nov 2013 01:37:30 +0800
X-Google-Sender-Auth: 82olwIIx0oBJc83kw_S5fmzwoPM
Message-ID: <CA+a=Yy4mgntUo0kpOYeghTRBZV4EtVHKE1KVgSXgGfFYqPAODQ@mail.gmail.com>
Subject: Re: How to create a config that doesn't set CONFIG_PROC_FS
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 1:17 AM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
> On Thu, Nov 28, 2013 at 4:02 PM, Peng Tao <lkml.bergwolf@gmail.com> wrote:
>> On Thu, Nov 28, 2013 at 9:20 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> On Thu, Nov 28, 2013 at 11:53 AM, Peng Tao <lkml.bergwolf@gmail.com> wrote:
>>>> Even if I use `make allnoconfig`, CONFIG_PROC_FS is still set. So I'm
>>>> wondering how to create a config without CONFIG_PROC_FS for build
>>>> testing?
>>>
>>> It can be disabled only if CONFIG_EXPERT=y.
>> Cool. Thank you very much!
>
> Out of curiosity, for which use case do you need that?
> Is is possible to run a sane userspace without procfs?
>
To be frank, I don't know. I just got build failure reports to fix up
when CONFIG_PROC_FS is off...

Thanks,
Tao
