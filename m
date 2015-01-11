Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbbAKKn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 05:43:26 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:53203 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbbAKKnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 05:43:22 -0500
MIME-Version: 1.0
In-Reply-To: <1420530835-8123-1-git-send-email-geert@linux-m68k.org>
References: <1420530835-8123-1-git-send-email-geert@linux-m68k.org>
Date: Sun, 11 Jan 2015 11:43:21 +0100
X-Google-Sender-Auth: i2CiuTnyxhhyMgMfHIhf3fi8eUs
Message-ID: <CAMuHMdUB_N12tu0Kdb3CkR+UHE3Kv7Pv7bHJex5+mvJWiJ_8Nw@mail.gmail.com>
Subject: Re: [PATCH] m68k: Switch to asm-generic/futex.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k <linux-m68k@vger.kernel.org>
Cc: Ley Foon Tan <lftan@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 8:53 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> As of commit 00f634bc522dedc8 ("asm-generic: add generic futex for
> !CONFIG_SMP") asm-generic follows the m68k futex implementation.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied and queued for 3.20.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
