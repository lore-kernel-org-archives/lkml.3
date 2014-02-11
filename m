Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaBKJop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:44:45 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:32961 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaBKJom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:44:42 -0500
MIME-Version: 1.0
In-Reply-To: <52F91C31.8060509@codethink.co.uk>
References: <1392037257-20607-1-git-send-email-geert+renesas@linux-m68k.org>
	<52F91C31.8060509@codethink.co.uk>
Date: Tue, 11 Feb 2014 10:44:41 +0100
X-Google-Sender-Auth: fkAuFLrCOH90EaYUF8QfCMVLY7k
Message-ID: <CAMuHMdULuOcyQ9J-KLg9Ssm3dZvrQb1=m66Ynyc+Q-G_4OtO=A@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: sh-pfc: r8a7790: Add QSPI pin groups
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Mon, Feb 10, 2014 at 7:36 PM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> On 10/02/14 13:00, Geert Uytterhoeven wrote:
>>
>> A QSPI function set consists of 3 groups:
>>    - qspi_ctrl (2 control wires)
>>    - qspi_data2 (2 data wires, for Single/Dual SPI)
>>    - qspi_data4 (4 data wires, for Quad SPI)
>
>
> Hi, do you have a branch with all your SPI/QSPI work on that we
> could have a test with please?

https://git.kernel.org/cgit/linux/kernel/git/geert/linux-m68k.git/log/?h=rcar-spi

This is based on renesas-devel-v3.14-rc1-20140207 and spi/for-next,
with accepted pinctrl and clock fixes, and the patches I sent out recently.
I left out the r7s72100/genmai stuff, as that depends on more out-of-tree
patches, and I think you're interested in Lager only?

Have fun!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
