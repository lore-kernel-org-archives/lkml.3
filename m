Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967543Ab3HIGYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:24:23 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:39383 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967319Ab3HIGYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:24:20 -0400
MIME-Version: 1.0
In-Reply-To: <62bf3fa5c57dd9155443dedb9116c18e2ac0689e.1374451989.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com> <62bf3fa5c57dd9155443dedb9116c18e2ac0689e.1374451989.git.joe@perches.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 9 Aug 2013 14:23:59 +0800
Message-ID: <CAGsJ_4yMB7V1gC9AebUV2z8ZzeWB-AeYpEWWF6AUBSCVff8_9w@mail.gmail.com>
Subject: Re: [PATCH 13/18] MAINTAINERS: Update sirf patterns
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/22 Joe Perches <joe@perches.com>:
> commit 3370dc916c ("pinctrl:sirf:re-arch and add support for
> new SiRFatlas6 SoC") moved the files, update the patterns.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: Barry Song <21cnbao@gmail.com>
> cc: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Barry Song <Baohua.Song@csr.com>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7622b04..6b24f82 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -813,7 +813,7 @@ F:  arch/arm/mach-prima2/
>  F:     drivers/dma/sirf-dma.c
>  F:     drivers/i2c/busses/i2c-sirf.c
>  F:     drivers/mmc/host/sdhci-sirf.c
> -F:     drivers/pinctrl/pinctrl-sirf.c
> +F:     drivers/pinctrl/sirf/
>  F:     drivers/spi/spi-sirf.c
>
>  ARM/EBSA110 MACHINE SUPPORT
> --
> 1.8.1.2.459.gbcd45b4.dirty
>
