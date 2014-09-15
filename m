Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaIOJvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:51:49 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35649 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbaIOJvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:51:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140912131755.7a181cc6@canb.auug.org.au>
References: <20140912131755.7a181cc6@canb.auug.org.au>
Date: Mon, 15 Sep 2014 11:51:43 +0200
X-Google-Sender-Auth: SmurUMGNK_PJlsZ9u80CA9AGJ-w
Message-ID: <CAMuHMdU0CkAhroWBq=ppjn+iDJ8_7kiSjJ3w7v5+TBjsLEjCkA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the slave-dma tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vinod Koul <vinod.koul@intel.com>, Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 5:17 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> After merging the slave-dma tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
>
> drivers/spi/spi-pxa2xx-pci.c:70:3: error: unknown field 'max_clk_rate' specified in initializer
>    .max_clk_rate = 50000000,
>    ^
>
> Caused by commit bfe607a528ba ("spi/pxa2xx-pci: Add support for Intel
> Braswell").
>
> I have used the slave-dma tree from next-20140911 for today.

It depends on commit afa93c9017fd48d4d5265854c75f5fcde0871548
("spi/pxa2xx-pci: Add common clock framework support in PCI glue layer")
from spi/for-next.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
