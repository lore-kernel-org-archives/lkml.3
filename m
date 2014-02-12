Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbaBLIUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:20:50 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:49959 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaBLIUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:20:48 -0500
MIME-Version: 1.0
In-Reply-To: <52FAC1F3.4050806@renesas.com>
References: <1389522649-1753-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdUYc8Ceid2z3c2Bm1ZDteu2iV-O4cPX4LdxiTnzhsh_Rw@mail.gmail.com>
	<52FAC1F3.4050806@renesas.com>
Date: Wed, 12 Feb 2014 09:20:48 +0100
X-Google-Sender-Auth: m1wqh06NKBaRIsrTiHhrjrPHShQ
Message-ID: <CAMuHMdVUvA2XT9L=JH=KJFa7sBjm8rxqHcMxg68gcFJgB=H_rA@mail.gmail.com>
Subject: Re: [PATCH] sh: sh7757: switch RSPI clock to dev ID match
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shimoda-san,

On Wed, Feb 12, 2014 at 1:36 AM, Shimoda, Yoshihiro
<yoshihiro.shimoda.uh@renesas.com> wrote:
> (2014/02/07 21:45), Geert Uytterhoeven wrote:
>> On Sun, Jan 12, 2014 at 11:30 AM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>>>
>>> Switch the RSPI MSTP clock on SH7757 from a con ID match to a dev ID
>>> match, so we can start looking it up using clk_get() with a NULL ID.
>>>
>>> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>>> ---
>>> Untested, as I don't have the hardware, but this is a prerequisite for
>>> "spi: rspi: Use NULL as the clock ID".
>>
>> Is there anyone who can test this?
>>
>> "spi: rspi: Use NULL as the clock ID" is queued for v3.15:
>> https://git.kernel.org/cgit/linux/kernel/git/broonie/spi.git/commit/drivers/spi/spi-rspi.c?h=for-next&id=29f397b739ceef90c8b848f6579cbacd088e896e
>> and this patch should go in first.
>>
>> Thanks!
>
> I could test this patch. And then, the patch worked correctly.

Thanks, I will add your Tested-by and send it to Andrew Morton.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
