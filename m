Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455Ab3K1NUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 08:20:16 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:57687 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab3K1NUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:20:08 -0500
MIME-Version: 1.0
In-Reply-To: <CA+a=Yy60b7nCjsXfczpOebbG27kJNoa9hPcdMHLJrN7qT5mfdg@mail.gmail.com>
References: <CA+a=Yy60b7nCjsXfczpOebbG27kJNoa9hPcdMHLJrN7qT5mfdg@mail.gmail.com>
Date: Thu, 28 Nov 2013 14:20:08 +0100
X-Google-Sender-Auth: zXOhBzIvh97pwFLcOrS95xIISZk
Message-ID: <CAMuHMdVS-EU0y+yLzdM=H20j7ewHKc_DAWFNL4Y1WE9_iNWVLA@mail.gmail.com>
Subject: Re: How to create a config that doesn't set CONFIG_PROC_FS
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peng Tao <lkml.bergwolf@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 11:53 AM, Peng Tao <lkml.bergwolf@gmail.com> wrote:
> Even if I use `make allnoconfig`, CONFIG_PROC_FS is still set. So I'm
> wondering how to create a config without CONFIG_PROC_FS for build
> testing?

It can be disabled only if CONFIG_EXPERT=y.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
