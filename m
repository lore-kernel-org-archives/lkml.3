Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbaBDSyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:54:55 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39087 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbaBDSyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:54:52 -0500
MIME-Version: 1.0
In-Reply-To: <20140204173733.GI22609@sirena.org.uk>
References: <1391527445-14881-1-git-send-email-geert@linux-m68k.org>
	<20140204173733.GI22609@sirena.org.uk>
Date: Tue, 4 Feb 2014 19:54:51 +0100
X-Google-Sender-Auth: DCpfHIZR6eHtHDSAIRfmCn4yReA
Message-ID: <CAMuHMdUHP8ptyjXh1n+iucygfAEAZCuwwe1tB1JjrTuGrhD3Pg@mail.gmail.com>
Subject: Re: [PATCH 00/11] ARM: shmobile: RSPI RZ and QSPI SoC and board integration
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Feb 4, 2014 at 6:37 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Feb 04, 2014 at 04:23:54PM +0100, Geert Uytterhoeven wrote:
>>       Hi Simon, Magnus,
>>
>> This patch series contains SoC and board integration for
>>   1. RSPI in the r7s72100 aka RZ/A1H SoC on the Genmai reference board,
>>   2. QSPI in the r8a7791 aka R-Car M2 SoC on the Koelsch reference board.
>> It was rebased on top of renesas-devel-v3.14-rc1-20140204.
>
> Can you please stop CCing arch/arm only patch serieses like this to the
> SPI list - they just mean I have to go through patchwork and mark them
> as not applicable.

Sorry, you're right. Only a few of them contained SPI-specific code.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
