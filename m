Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbaCQNXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:23:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805AbaCQNXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:23:44 -0400
Message-ID: <5326F746.1080507@redhat.com>
Date: Mon, 17 Mar 2014 14:23:18 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Oliver Schinagl <oliver@schinagl.nl>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci_sunxi: fix code formatting
References: <10509185.3UEOEZKTc5@amdc1032>
In-Reply-To: <10509185.3UEOEZKTc5@amdc1032>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/17/2014 02:08 PM, Bartlomiej Zolnierkiewicz wrote:
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Thanks for doing these clean-ups.

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

> ---
>  drivers/ata/ahci_sunxi.c |   44 ++++++++++++++++++++++----------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
> 
> Index: b/drivers/ata/ahci_sunxi.c
> ===================================================================
> --- a/drivers/ata/ahci_sunxi.c	2014-03-17 13:59:06.220474478 +0100
> +++ b/drivers/ata/ahci_sunxi.c	2014-03-17 14:00:48.720472730 +0100
> @@ -27,28 +27,28 @@
>  #include <linux/regulator/consumer.h>
>  #include "ahci.h"
>  
> -#define AHCI_BISTAFR 0x00a0
> -#define AHCI_BISTCR 0x00a4
> -#define AHCI_BISTFCTR 0x00a8
> -#define AHCI_BISTSR 0x00ac
> -#define AHCI_BISTDECR 0x00b0
> -#define AHCI_DIAGNR0 0x00b4
> -#define AHCI_DIAGNR1 0x00b8
> -#define AHCI_OOBR 0x00bc
> -#define AHCI_PHYCS0R 0x00c0
> -#define AHCI_PHYCS1R 0x00c4
> -#define AHCI_PHYCS2R 0x00c8
> -#define AHCI_TIMER1MS 0x00e0
> -#define AHCI_GPARAM1R 0x00e8
> -#define AHCI_GPARAM2R 0x00ec
> -#define AHCI_PPARAMR 0x00f0
> -#define AHCI_TESTR 0x00f4
> -#define AHCI_VERSIONR 0x00f8
> -#define AHCI_IDR 0x00fc
> -#define AHCI_RWCR 0x00fc
> -#define AHCI_P0DMACR 0x0170
> -#define AHCI_P0PHYCR 0x0178
> -#define AHCI_P0PHYSR 0x017c
> +#define AHCI_BISTAFR	0x00a0
> +#define AHCI_BISTCR	0x00a4
> +#define AHCI_BISTFCTR	0x00a8
> +#define AHCI_BISTSR	0x00ac
> +#define AHCI_BISTDECR	0x00b0
> +#define AHCI_DIAGNR0	0x00b4
> +#define AHCI_DIAGNR1	0x00b8
> +#define AHCI_OOBR	0x00bc
> +#define AHCI_PHYCS0R	0x00c0
> +#define AHCI_PHYCS1R	0x00c4
> +#define AHCI_PHYCS2R	0x00c8
> +#define AHCI_TIMER1MS	0x00e0
> +#define AHCI_GPARAM1R	0x00e8
> +#define AHCI_GPARAM2R	0x00ec
> +#define AHCI_PPARAMR	0x00f0
> +#define AHCI_TESTR	0x00f4
> +#define AHCI_VERSIONR	0x00f8
> +#define AHCI_IDR	0x00fc
> +#define AHCI_RWCR	0x00fc
> +#define AHCI_P0DMACR	0x0170
> +#define AHCI_P0PHYCR	0x0178
> +#define AHCI_P0PHYSR	0x017c
>  
>  static void sunxi_clrbits(void __iomem *reg, u32 clr_val)
>  {
> 
