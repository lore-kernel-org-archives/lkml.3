Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbbANKWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 05:22:00 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:46129 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbbANKV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 05:21:58 -0500
MIME-Version: 1.0
In-Reply-To: <1421162244-5980-1-git-send-email-md.jamalmohiuddin@gmail.com>
References: <1421162244-5980-1-git-send-email-md.jamalmohiuddin@gmail.com>
Date: Wed, 14 Jan 2015 11:21:57 +0100
Message-ID: <CAPDyKFpP4a2DOprszdZtZ4q1=yQcE2UL8+t76YRdnROURLwRqw@mail.gmail.com>
Subject: Re: [PATCH] mmc: host: sdhci: Added a space before (
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Cc: Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 January 2015 at 16:17, Mohammad Jamal <md.jamalmohiuddin@gmail.com> wrote:
> This patch solves the coding style issue by adding a space
> before (
>
> Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>

Thanks! Applied for next.

Kind regards
Uffe

> ---
>  drivers/mmc/host/sdhci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 1453cd1..910ee7b 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1624,7 +1624,7 @@ static void sdhci_do_set_ios(struct sdhci_host *host, struct mmc_ios *ios)
>          * signalling timeout and CRC errors even on CMD0. Resetting
>          * it on each ios seems to solve the problem.
>          */
> -       if(host->quirks & SDHCI_QUIRK_RESET_CMD_DATA_ON_IOS)
> +       if (host->quirks & SDHCI_QUIRK_RESET_CMD_DATA_ON_IOS)
>                 sdhci_do_reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
>
>         mmiowb();
> --
> 1.7.9.5
>
