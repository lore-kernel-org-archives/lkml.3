Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344AbaH0NOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:14:24 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:37313 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270AbaH0NOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:14:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140819211704.GS24407@sirena.org.uk>
References: <1408466947-26593-1-git-send-email-swarren@wwwdotorg.org>
	<20140819211704.GS24407@sirena.org.uk>
Date: Wed, 27 Aug 2014 15:14:21 +0200
X-Google-Sender-Auth: ZFB9RY9pTUbTj3jyoku0LZNAboU
Message-ID: <CAMuHMdW1Ev9uTnWXTQxE0S+1SX2ahA7hFjHvb6JC5iRzgLJGFw@mail.gmail.com>
Subject: Re: [PATCH V2] regmap: of_regmap_get_endian() cleanup
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <treding@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Aug 19, 2014 at 11:17 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Aug 19, 2014 at 10:49:07AM -0600, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Commit d647c199510c ("regmap: add DT endianness binding support") had
>> some issues. Commit ba1b53feb8ca ("regmap: Fix DT endianess parsing
>> logic") fixed the main problem. This patch fixes the other.
>
> Applied, thanks.

Doh, wish I'd seen this thread earlier...

This morning I was greeted by some crashes, as your spi/for-next branch
has just pulled in spi/topic/fsl-dspi, which contains regmap/dt-endian, but
not the fixes :-(

You may want to pull those in, too.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
