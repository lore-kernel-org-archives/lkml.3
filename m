Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbbADThF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 14:37:05 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:40276 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbbADThB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 14:37:01 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1501041045020.15927@nippy.intranet>
References: <1420131732-31039-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<alpine.LNX.2.00.1501041045020.15927@nippy.intranet>
Date: Sun, 4 Jan 2015 20:36:59 +0100
X-Google-Sender-Auth: NSXx-rPQbeGa5fcUkTR_n0DVd-E
Message-ID: <CAMuHMdXFu3n4d0dMZop186UF+QG=MtLHV=oQr+VszftpEA1kFQ@mail.gmail.com>
Subject: Re: [PATCH] arch: m68k: mac: misc.c: Remove some unused functions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Joshua Thompson <funaho@jurai.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2015 at 8:21 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> On Thu, 1 Jan 2015, Rickard Strandqvist wrote:
>> Removes some functions that are not used anywhere:
>> mac_pram_write() mac_pram_read()
>
> If you remove those functions, you'd then find that all of the called
> functions become unused:
>
> maciisi_read_pram
> maciisi_write_pram
> pmu_read_pram
> pmu_write_pram
> cuda_read_pram
> cuda_write_pram
> via_read_pram
> via_write_pram
>
> I'd rather not remove all of this code. Better to finish the
> implementation.

Indeed.

> Would it be acceptable to utilize drivers/char/generic_nvram.c and
> CONFIG_GENERIC_NVRAM? This is the PowerMac PRAM driver but looks generic
> enough that it may not need any modification for 68k Macs.

Yes, that would be great.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
