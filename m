Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716Ab3GSG6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 02:58:13 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:50888 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab3GSG6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 02:58:11 -0400
MIME-Version: 1.0
In-Reply-To: <db631755ca657e2841de51e72304fa6598c98508.1373970214.git.viresh.kumar@linaro.org>
References: <db631755ca657e2841de51e72304fa6598c98508.1373970214.git.viresh.kumar@linaro.org>
Date: Fri, 19 Jul 2013 09:58:11 +0300
Message-ID: <CAHp75VfzPB1-AUkVG_is8qk_b-zRoNM09iRu33xKj1TvSZmvvg@mail.gmail.com>
Subject: Re: [PATCH] dmaengine/MAINTAINERS: Add Andy as Co-Maintainer of DW
 DMA Controller
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shevchenko, Andy" <andriy.shevchenko@linux.intel.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 6:43 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Andy has done enough work on Synopsys Designware DMA Controller and I believe he
> should Co-Maintain this driver along with me. So this patch.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks.

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5d3facf..a4d57d9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7111,6 +7111,7 @@ F:        drivers/tty/serial
>
>  SYNOPSYS DESIGNWARE DMAC DRIVER
>  M:     Viresh Kumar <viresh.linux@gmail.com>
> +M:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>  S:     Maintained
>  F:     include/linux/dw_dmac.h
>  F:     drivers/dma/dw/
> --
> 1.7.12.rc2.18.g61b472e
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--
With Best Regards,
Andy Shevchenko
