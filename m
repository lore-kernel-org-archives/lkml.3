Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3GIJyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:54:13 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52404 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab3GIJyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:54:11 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUV3cH5r6gScYt18tpaJx49oXtrn56BMTuj5jJQwvd_zig@mail.gmail.com>
References: <20130709170155.a212513b3a95d78e404e70db@canb.auug.org.au>
	<CA+icZUV3cH5r6gScYt18tpaJx49oXtrn56BMTuj5jJQwvd_zig@mail.gmail.com>
Date: Tue, 9 Jul 2013 11:54:10 +0200
Message-ID: <CA+icZUVw4KSG7rJkY+EBniwfceHzYYXTXzqB-9rCiTkLBLb2XQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 9
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 9, 2013 at 11:50 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Jul 9, 2013 at 9:01 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> Changes since 20130708:
>>
>> The v4l-dvb tree lost its build failure.
>>
>> The tip tree gained a conflict against Linus' tree.
>>
>> The akpm tree lost a patch that turned up elsewhere.
>>
>> The cpuinit tree lost some patches that turned up in Linus' tree.
>>
>> ----------------------------------------------------------------------------
>>
>
> Hi,
>
> I got today several emails from Andrew, that some post-fixes to
> existing patches in mmotm got merged.
> Looking into mmotm patch-series, it was not updated since 03-Jul-2013.
>
> From where is [1]?
> It has "memcg: fix build error if CONFIG_MEMCG_KMEM=n" folded in.
> Isn't the procedure to get all these patches from Andrew's mmotm?
> BTW, the new patch has no furher informations or a vX history and my
> credits are gone, too.
>

Hmmm, another patch where I was involved...

Original: "ipc,msg: shorten critical region in msgrcv"
Post-Fix: "ipc,msq: fix race in msgrcv(2)"

...strange, not folded in.

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=188ba7fb13646c4a4de00a315fbddc2f4cba1d20
[2] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=74bd175d0d237894c14adcf0479dd9f22b30c77b

> - Sedat -
>
>
> [0] http://ozlabs.org/~akpm/mmotm/broken-out/
> [1] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/mm/memcontrol.c?id=958f4381fa3cb7abd6f63103c9099e648595a27e
