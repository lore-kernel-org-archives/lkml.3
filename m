Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaHRLl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:41:27 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:45018 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaHRLl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:41:26 -0400
MIME-Version: 1.0
In-Reply-To: <1408034728-4952-2-git-send-email-abrestic@chromium.org>
References: <1408034728-4952-1-git-send-email-abrestic@chromium.org>
	<1408034728-4952-2-git-send-email-abrestic@chromium.org>
Date: Mon, 18 Aug 2014 13:41:25 +0200
Message-ID: <CAPDyKFrC9yHHU6bcLOgcs0do9fUPWc9VNBUCtbKzz1j_D0n+Pg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mmc: dw_mmc: Add support for MIPS
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 August 2014 18:45, Andrew Bresticker <abrestic@chromium.org> wrote:
> There are upcoming MIPS SoCs with dw_mmc hosts.
>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>

Thanks! Applied for next.

Kind regards
Uffe


> ---
>  drivers/mmc/host/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 385674b..6acc2ab 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -564,7 +564,7 @@ config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
>  config MMC_DW
>         tristate "Synopsys DesignWare Memory Card Interface"
>         depends on HAS_DMA
> -       depends on ARC || ARM || COMPILE_TEST
> +       depends on ARC || ARM || MIPS || COMPILE_TEST
>         help
>           This selects support for the Synopsys DesignWare Mobile Storage IP
>           block, this provides host support for SD and MMC interfaces, in both
> --
> 2.1.0.rc2.206.gedb03e5
>
