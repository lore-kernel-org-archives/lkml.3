Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbbAMIsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:48:55 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:56405 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbbAMIsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:48:54 -0500
MIME-Version: 1.0
In-Reply-To: <1409328896-8457-1-git-send-email-geert@linux-m68k.org>
References: <1409328896-8457-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 13 Jan 2015 09:48:52 +0100
X-Google-Sender-Auth: ZDjf374ca_bYntYmPpl1CVVwHPw
Message-ID: <CAMuHMdX7CMfHid6=Px4+m6Urph7Vs-av+tr+12zOFbt7TqX+sQ@mail.gmail.com>
Subject: Re: [PATCH] m68k/atari: Remove obsolete keyboard_tasklet scheduling
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 6:14 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> If CONFIG_VT=n:
>
> arch/m68k/atari/built-in.o: In function `atari_keyboard_interrupt':
> atakeyb.c:(.text+0x1846): undefined reference to `keyboard_tasklet'
> atakeyb.c:(.text+0x1852): undefined reference to `keyboard_tasklet'
>
> I think the keyboard_tasklet scheduling is no longer needed, as I
> believe it's handled by drivers/tty/vt/keyboard.c based on events
> received from the input subsystem. So just remove it.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied with Michael's Tested-by, and queued for 3.20.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
