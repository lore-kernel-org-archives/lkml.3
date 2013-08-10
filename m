Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031806Ab3HJCKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 22:10:07 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:62283 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031757Ab3HJCKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 22:10:05 -0400
MIME-Version: 1.0
In-Reply-To: <52059508.3090405@sr71.net>
References: <520578D0.7020607@intel.com>
	<CAE9FiQUuPmZfhsHvmsS+_O_VOWMA_OBAexGyRF3eZR1_D3EehA@mail.gmail.com>
	<52059508.3090405@sr71.net>
Date: Fri, 9 Aug 2013 19:10:03 -0700
X-Google-Sender-Auth: MDdO_m7jfcrOe8pZudw7F4Z5TBA
Message-ID: <CAE9FiQVvo+saJFpx=6A8O7GOns0cR302_GBe4A0a10a4Z0mZyw@mail.gmail.com>
Subject: Re: x86: early boot crash: "alloc_low_page: ran out of memory" (bisected)
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 9, 2013 at 6:19 PM, Dave Hansen <dave@sr71.net> wrote:
> On 08/09/2013 04:23 PM, Yinghai Lu wrote:
>> On Fri, Aug 9, 2013 at 4:18 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>>> I'm getting a 100% reproducible panic early in boot:
> ...
>>>> early console in setup code
>>>> [    0.000000] Initializing cgroup subsys cpuset
>>>> [    0.000000] Initializing cgroup subsys cpu
>>>> [    0.000000] Linux version 3.8.0-rc5-00059-g8170e6b
>>
>> so how about v3.10?
>>
>> We should have some fixes in 3.10 already.
>
> I was hitting it on Linus's current tree today (3.11-rcwhatever).  I
> pasted the panic() from your patch's commit specifically, but the same
> behavior is happening on current kernels, and it looked consistent as I
> bisected between the 3.11-rc's and your commit.

Can you post 3.11-rc with "debug ignore_loglevel memblock=debug" ?

Thanks

Yinghai
