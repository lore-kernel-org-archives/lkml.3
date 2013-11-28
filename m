Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab3K1PDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:03:23 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:56680 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab3K1PDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:03:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVS-EU0y+yLzdM=H20j7ewHKc_DAWFNL4Y1WE9_iNWVLA@mail.gmail.com>
References: <CA+a=Yy60b7nCjsXfczpOebbG27kJNoa9hPcdMHLJrN7qT5mfdg@mail.gmail.com>
 <CAMuHMdVS-EU0y+yLzdM=H20j7ewHKc_DAWFNL4Y1WE9_iNWVLA@mail.gmail.com>
From: Peng Tao <lkml.bergwolf@gmail.com>
Date: Thu, 28 Nov 2013 23:02:58 +0800
X-Google-Sender-Auth: -mGPZX6spnx5KX-FZZ5dmIX3i0M
Message-ID: <CA+a=Yy5Q=urtPfLEcu0WDJngo_COOZGnBuuVkkwUezKfcoGEwA@mail.gmail.com>
Subject: Re: How to create a config that doesn't set CONFIG_PROC_FS
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 9:20 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Thu, Nov 28, 2013 at 11:53 AM, Peng Tao <lkml.bergwolf@gmail.com> wrote:
>> Even if I use `make allnoconfig`, CONFIG_PROC_FS is still set. So I'm
>> wondering how to create a config without CONFIG_PROC_FS for build
>> testing?
>
> It can be disabled only if CONFIG_EXPERT=y.
Cool. Thank you very much!

Cheers,
Tao
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
