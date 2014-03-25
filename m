Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaCYW2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:28:32 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:42016 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaCYW2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:28:31 -0400
MIME-Version: 1.0
In-Reply-To: <1394512286-31481-1-git-send-email-nunes.erico@gmail.com>
References: <1394512286-31481-1-git-send-email-nunes.erico@gmail.com>
Date: Tue, 25 Mar 2014 19:28:30 -0300
Message-ID: <CAK4VdL33t-rbVGfj5xH3nVeGt5fjnZjvcNH+zZ=4Dibj7snsYg@mail.gmail.com>
Subject: Re: [PATCH] mtd: nand: fix mention to CONFIG_MTD_NAND_ECC_BCH
From: Erico Nunes <nunes.erico@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>, b32955@freescale.com,
        artem.bityutskiy@linux.intel.com,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Erico Nunes <nunes.erico@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-11 1:31 GMT-03:00 Erico Nunes <nunes.erico@gmail.com>:
> Mention to CONFIG_MTD_ECC_BCH in the warning message can be confusing as this
> doesn't match the exact name of the configuration option.
> This warning showed up once to me when I was starting to set up BCH. After
> checking my .config file, it took a moment before realizing it is
> CONFIG_MTD_NAND_ECC_BCH instead of CONFIG_MTD_ECC_BCH.
>
> Signed-off-by: Erico Nunes <nunes.erico@gmail.com>
> ---
>  drivers/mtd/nand/nand_base.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index 9715a7b..5a93787 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -3825,7 +3825,7 @@ int nand_scan_tail(struct mtd_info *mtd)
>
>         case NAND_ECC_SOFT_BCH:
>                 if (!mtd_nand_has_bch()) {
> -                       pr_warn("CONFIG_MTD_ECC_BCH not enabled\n");
> +                       pr_warn("CONFIG_MTD_NAND_ECC_BCH not enabled\n");
>                         BUG();
>                 }
>                 ecc->calculate = nand_bch_calculate_ecc;
> --
> 1.9.0
>

Ping.
