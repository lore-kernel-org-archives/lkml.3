Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaGDIzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:55:08 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56414 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaGDIzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:55:05 -0400
MIME-Version: 1.0
In-Reply-To: <53B66A9F.6040404@hisilicon.com>
References: <53B66A9F.6040404@hisilicon.com>
Date: Fri, 4 Jul 2014 16:54:58 +0800
Message-ID: <CAD6h2NR+5K35WYPb-4ih0arb=Tqr+Q837i0sXpA12Smims2OEA@mail.gmail.com>
Subject: Re: [PATCH v2] MAINTAINERS:ARM:hisi: add Hisilicon SoC family
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: xuwei <xuwei5@hisilicon.com>
Cc: Li Zefan <lizefan@huawei.com>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 July 2014 16:49, xuwei <xuwei5@hisilicon.com> wrote:
> Introduce a new mach-hisi that will support Hisilicon SoCs based on ARMv7
> and I am taking maintainership for it.
>
> Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 134483f..a4f700a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -972,6 +972,14 @@ F: arch/arm/mach-pxa/hx4700.c
>  F:     arch/arm/mach-pxa/include/mach/hx4700.h
>  F:     sound/soc/pxa/hx4700.c
>
> +ARM/Hisilicon SoC support
> +M:     Wei Xu <xuwei5@hisilicon.com>
> +L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +W:     www.hisilicon.com
> +S:     Supported
> +T:     git git://github.com/hisilicon/linux-hisi.git
> +F:     arch/arm/mach-hisi/
> +
>  ARM/HP JORNADA 7XX MACHINE SUPPORT
>  M:     Kristoffer Ericson <kristoffer.ericson@gmail.com>
>  W:     www.jlime.com
> --
> 1.8.1.2
>

Acked-by: Haojian Zhuang <haojian.zhuang@linaro.org>

Best Regards
Haojian
