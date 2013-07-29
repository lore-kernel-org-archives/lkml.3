Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab3G2RW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:22:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49361 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3G2RW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:22:58 -0400
Message-ID: <51F6A4B4.3020100@infradead.org>
Date: Mon, 29 Jul 2013 10:21:56 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Robin Gong <b38343@freescale.com>
CC: lgirdwood@gmail.com, broonie@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator:pfuze100: add MODULE_LICENSE() in pfuze100
 driver
References: <1375069211-32069-1-git-send-email-b38343@freescale.com>
In-Reply-To: <1375069211-32069-1-git-send-email-b38343@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/13 20:40, Robin Gong wrote:
> Fix building error on x86_64 and i386:
> WARNING: modpost: missing MODULE_LICENSE() in
> drivers/regulator/pfuze100-regulator.o
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/regulator/pfuze100-regulator.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
> index e2f9dcf..2dadc31 100644
> --- a/drivers/regulator/pfuze100-regulator.c
> +++ b/drivers/regulator/pfuze100-regulator.c
> @@ -451,4 +451,5 @@ module_i2c_driver(pfuze_driver);
>  
>  MODULE_AUTHOR("Robin Gong <b38343@freescale.com>");
>  MODULE_DESCRIPTION("Regulator Driver for Freescale PFUZE100 PMIC");
> +MODULE_LICENSE("GPL v2");
>  MODULE_ALIAS("pfuze100-regulator");
> 


-- 
~Randy
