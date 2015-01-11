Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbbAKKm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 05:42:26 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:64040 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbbAKKmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 05:42:24 -0500
MIME-Version: 1.0
In-Reply-To: <1420126677-27948-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420126677-27948-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sun, 11 Jan 2015 11:42:22 +0100
X-Google-Sender-Auth: 02gOr9Ws1veQzOmDKxQ41H9Gpfg
Message-ID: <CAMuHMdXA+geFx56t61Ec-pb9WaB_yvP7S1NyFVcHoMcTSrYVSQ@mail.gmail.com>
Subject: Re: [PATCH] arch: m68k: atari: atakeyb.c: Remove some unused functions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2015 at 4:37 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Removes some functions that are not used anywhere:
> atari_kbd_leds() ikbd_exec() ikbd_mem_read() ikbd_mem_write()
> ikbd_clock_get() ikbd_clock_set() ikbd_pause() ikbd_resume()
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Thanks, applied and queued for 3.20.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
