Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaIJPA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:00:59 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60236 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaIJPA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:00:57 -0400
X-Auth-Info: WhZNkuB5vuzStiQNYHs9/m0yOOBYYhC2GIX3uWuiVw4=
From: Marek Vasut <marex@denx.de>
To: Rostislav Lisovy <lisovy@gmail.com>
Subject: Re: [PATCH] mtd: spi-nor: Add support for Fujitsu MB85RS1MT FRAM
Date: Wed, 10 Sep 2014 16:55:19 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <b32955@freescale.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, sojkam1@fel.cvut.cz,
        michal.vokac@comap.cz, Rostislav Lisovy <lisovy@merica.cz>
References: <1410339230-13007-1-git-send-email-lisovy@merica.cz>
In-Reply-To: <1410339230-13007-1-git-send-email-lisovy@merica.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201409101655.19155.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 10, 2014 at 10:53:50 AM, Rostislav Lisovy wrote:
> Tested with this particular FRAM chip
> 
> Signed-off-by: Rostislav Lisovy <lisovy@merica.cz>
> ---
>  drivers/mtd/spi-nor/spi-nor.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
> index b5ad6be..a914be9 100644
> --- a/drivers/mtd/spi-nor/spi-nor.c
> +++ b/drivers/mtd/spi-nor/spi-nor.c
> @@ -505,6 +505,9 @@ const struct spi_device_id spi_nor_ids[] = {
>  	{ "mr25h256", CAT25_INFO( 32 * 1024, 1, 256, 2, SPI_NOR_NO_ERASE |
> SPI_NOR_NO_FR) }, { "mr25h10",  CAT25_INFO(128 * 1024, 1, 256, 3,
> SPI_NOR_NO_ERASE | SPI_NOR_NO_FR) },
> 
> +	/* Fujitsu */
> +	{ "mb85rs1mt", INFO(0x047f27, 0, 128 * 1024, 1, SPI_NOR_NO_ERASE) },
> +
>  	/* GigaDevice */
>  	{ "gd25q32", INFO(0xc84016, 0, 64 * 1024,  64, SECT_4K) },
>  	{ "gd25q64", INFO(0xc84017, 0, 64 * 1024, 128, SECT_4K) },

Looks OK,

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
