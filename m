Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbaIHW27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:28:59 -0400
Received: from mail-yk0-f181.google.com ([209.85.160.181]:44655 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaIHW26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:28:58 -0400
MIME-Version: 1.0
In-Reply-To: <1409307891-16523-1-git-send-email-alim.akhtar@samsung.com>
References: <1409307891-16523-1-git-send-email-alim.akhtar@samsung.com>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Tue, 9 Sep 2014 03:58:17 +0530
Message-ID: <CAGOxZ50__yVJPCF1f8fjFfX3uyZ+G_=VYA0UdCAcsLdcjLtewA@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: add support for ARM64
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chrish, Ulf, Arnd

Any comments/suggestions?

On Fri, Aug 29, 2014 at 3:54 PM, Alim Akhtar <alim.akhtar@samsung.com> wrote:
> There are upcoming ARM64 SoCs with dw_mmc host controller.
>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  drivers/mmc/host/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index a43295c..72dd6c2 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -580,7 +580,7 @@ config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
>  config MMC_DW
>         tristate "Synopsys DesignWare Memory Card Interface"
>         depends on HAS_DMA
> -       depends on ARC || ARM || MIPS || COMPILE_TEST
> +       depends on ARC || ARM || ARM64 || MIPS || COMPILE_TEST
>         help
>           This selects support for the Synopsys DesignWare Mobile Storage IP
>           block, this provides host support for SD and MMC interfaces, in both
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,
Alim
