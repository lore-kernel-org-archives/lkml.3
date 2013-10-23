Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab3JWNq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:46:28 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:36272 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab3JWNq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:46:27 -0400
Message-ID: <5267D2DD.5000309@parrot.com>
Date: Wed, 23 Oct 2013 15:45:01 +0200
From: Jeremie Samuel <jeremie.samuel.ext@parrot.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Chris Ball <cjb@laptop.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: sdhci: dove: Fix build breakage
References: <1382533832-21085-1-git-send-email-treding@nvidia.com>
In-Reply-To: <1382533832-21085-1-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.218.109.88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soory, I thought I had corrected this typo.

Signed-off-by: Jeremie Samuel <jeremie.samuel.ext@parrot.com>

-- 
Jeremie Samuel              Parrot S.A.
Software Engineer           14, quai de Jemmapes
R&D/OS Platform             75010 Paris, France
http://www.parrot.com

On 23/10/2013 15:10, Thierry Reding wrote:
> Commit 2d7c51f (mmc: sdhci: Use work structs instead of tasklets)
> converts tasklets to work structs, but typos the conversion in the Dove
> driver.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>   drivers/mmc/host/sdhci-dove.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sdhci-dove.c b/drivers/mmc/host/sdhci-dove.c
> index 45c7f25..95f1076 100644
> --- a/drivers/mmc/host/sdhci-dove.c
> +++ b/drivers/mmc/host/sdhci-dove.c
> @@ -39,7 +39,7 @@ static irqreturn_t sdhci_dove_carddetect_irq(int irq, void *data)
>   {
>   	struct sdhci_host *host = data;
>   
> -	schedule_schedule(&host->card_detect_work);
> +	schedule_work(&host->card_detect_work);
>   	return IRQ_HANDLED;
>   }
>   

