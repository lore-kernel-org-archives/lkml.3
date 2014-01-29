Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaA2TKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 14:10:42 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:45470 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaA2TKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:10:38 -0500
MIME-Version: 1.0
In-Reply-To: <20140129180009.GF22609@sirena.org.uk>
References: <1390900898-31579-1-git-send-email-geert@linux-m68k.org>
	<20140129180009.GF22609@sirena.org.uk>
Date: Wed, 29 Jan 2014 20:10:34 +0100
X-Google-Sender-Auth: jDojFJUePmtl0EyuijUHVf9dF_U
Message-ID: <CAMuHMdX+EUUHxOgc8RF=C=qdYiOc8h+su4r-=HAhWXUqEivSvw@mail.gmail.com>
Subject: Re: [PATCH v5] spi: rspi: Add DT support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Jan 29, 2014 at 7:00 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Jan 28, 2014 at 10:21:38AM +0100, Geert Uytterhoeven wrote:
>> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>
> Applied, thanks.  I was expecting your last patch to be resubmitted as

Thanks!

> well?

As there were no code changes in v5 of "spi: rspi: Add DT support",
Patch "[14/14] spi: rspi: Add support for Quad and Dual SPI Transfers on QSPI"
should still apply fine.

Do you want me to resubmit?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus TorvaldsHi M
