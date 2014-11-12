Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaKLOLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:11:12 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:36455 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaKLOLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:11:10 -0500
MIME-Version: 1.0
In-Reply-To: <1409307891-16523-1-git-send-email-alim.akhtar@samsung.com>
References: <1409307891-16523-1-git-send-email-alim.akhtar@samsung.com>
Date: Wed, 12 Nov 2014 15:11:09 +0100
Message-ID: <CAPDyKFp_XZ=93wisFScezHLqDWDz5XjqxHV1w13zmU3nzQrZww@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: add support for ARM64
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Chris Ball <chris@printf.net>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 August 2014 12:24, Alim Akhtar <alim.akhtar@samsung.com> wrote:
> There are upcoming ARM64 SoCs with dw_mmc host controller.
>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>

Thanks! Applied for next.

Kind regards
Uffe

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
