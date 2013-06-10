Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3FJDku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 23:40:50 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:50820 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab3FJDkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 23:40:47 -0400
MIME-Version: 1.0
In-Reply-To: <1366104482-14240-1-git-send-email-ks.giri@samsung.com>
References: <1366104482-14240-1-git-send-email-ks.giri@samsung.com>
Date: Mon, 10 Jun 2013 09:10:45 +0530
Message-ID: <CAKrE-Kc5aSdQcphVrq74xgHOxnEs3frZqjHzf_7bvvgwQWHY0g@mail.gmail.com>
Subject: Re: [PATCH V2] ahci: sata: add support for exynos5440 sata
From: Girish KS <girishks2000@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,
can this patch be pulled in for 3.11

On Tue, Apr 16, 2013 at 2:58 PM, Girish K S <girishks2000@gmail.com> wrote:
> This patch adds the compatible string of the exynos5440 sata controller
> compliant with the ahci 1.3 and sata 3.0 specification.
>
> Signed-off-by: Girish K S <ks.giri@samsung.com>
>
> changes in v2:
>                 changed the compatible string by adding the actual IP
> owners name instead of the SoC vendor name.
>
> ---
>  drivers/ata/ahci_platform.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index 7a8a284..c06f021 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -327,6 +327,7 @@ static SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_suspend, ahci_resume);
>
>  static const struct of_device_id ahci_of_match[] = {
>         { .compatible = "snps,spear-ahci", },
> +       { .compatible = "snps,exynos5440-ahci", },
>         {},
>  };
>  MODULE_DEVICE_TABLE(of, ahci_of_match);
> --
> 1.7.5.4
>
