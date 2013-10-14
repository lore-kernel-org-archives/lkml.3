Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab3JNKRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:17:21 -0400
Received: from hardeman.nu ([95.142.160.32]:35777 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab3JNKRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:17:17 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Oct 2013 06:17:17 EDT
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] [media] winbond-cir: remove deprecated  =?UTF-8?Q?IRQF=5FDISABLED?=
X-PHP-Originating-Script: 0:rcmail.php
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Mon, 14 Oct 2013 12:07:32 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: m.chehab@samsung.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
In-Reply-To: <1381644672-9283-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381644672-9283-1-git-send-email-michael.opdenacker@free-electrons.com>
Message-ID: <23ea039a250b4b074fb89a653e0c5c18@hardeman.nu>
User-Agent: Roundcube Webmail/0.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-10-13 08:11, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker 
> <michael.opdenacker@free-electrons.com>
Acked-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/winbond-cir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/winbond-cir.c 
> b/drivers/media/rc/winbond-cir.c
> index 98bd496..904baf4 100644
> --- a/drivers/media/rc/winbond-cir.c
> +++ b/drivers/media/rc/winbond-cir.c
> @@ -1110,7 +1110,7 @@ wbcir_probe(struct pnp_dev *device, const struct
> pnp_device_id *dev_id)
>  	}
> 
>  	err = request_irq(data->irq, wbcir_irq_handler,
> -			  IRQF_DISABLED, DRVNAME, device);
> +			  0, DRVNAME, device);
>  	if (err) {
>  		dev_err(dev, "Failed to claim IRQ %u\n", data->irq);
>  		err = -EBUSY;
