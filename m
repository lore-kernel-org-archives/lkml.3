Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbaIIGvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:51:50 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:35276 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaIIGvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:51:49 -0400
MIME-Version: 1.0
In-Reply-To: <1409307891-16523-1-git-send-email-alim.akhtar@samsung.com>
References: <1409307891-16523-1-git-send-email-alim.akhtar@samsung.com>
Date: Tue, 9 Sep 2014 08:51:48 +0200
Message-ID: <CAPDyKFqk1pwGFuitE0Fk1pqyP_FZiQK1=5OtGUM9Zw6Mp_rWXw@mail.gmail.com>
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

Before enabling this, wouldn't it be better to add the needed support
in dw_mmc first? Or there are no changes needed?

There are also ongoing development and discussions for exynos7, which
I guess relates to this?
http://www.spinics.net/lists/linux-mmc/msg28294.html

Kind regards
Uffe
