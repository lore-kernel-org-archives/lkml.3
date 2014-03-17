Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229AbaCQNXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:23:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805AbaCQNXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:23:42 -0400
Message-ID: <5326F73B.6080501@redhat.com>
Date: Mon, 17 Mar 2014 14:23:07 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Oliver Schinagl <oliver@schinagl.nl>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci_sunxi: make ahci_sunxi_resume() static
References: <1725454.bVvdm9zQru@amdc1032>
In-Reply-To: <1725454.bVvdm9zQru@amdc1032>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/17/2014 02:06 PM, Bartlomiej Zolnierkiewicz wrote:
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Thanks for doing these clean-ups.

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> ---
>  drivers/ata/ahci_sunxi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/drivers/ata/ahci_sunxi.c
> ===================================================================
> --- a/drivers/ata/ahci_sunxi.c	2014-03-17 13:59:05.556474489 +0100
> +++ b/drivers/ata/ahci_sunxi.c	2014-03-17 13:59:06.220474478 +0100
> @@ -209,7 +209,7 @@ disable_resources:
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> -int ahci_sunxi_resume(struct device *dev)
> +static int ahci_sunxi_resume(struct device *dev)
>  {
>  	struct ata_host *host = dev_get_drvdata(dev);
>  	struct ahci_host_priv *hpriv = host->private_data;
> 
