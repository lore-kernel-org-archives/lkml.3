Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaIOSBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:01:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54264 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbaIOSBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:01:13 -0400
Message-ID: <5417294C.2010506@ti.com>
Date: Mon, 15 Sep 2014 13:00:44 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] Input: palmas-pwrbutton: Fix typo in License
References: <1410803937-27022-1-git-send-email-nm@ti.com>
In-Reply-To: <1410803937-27022-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 12:58 PM, Nishanth Menon wrote:
> Follow the license string convention indicated in include/linux/module.h
> (don't capitalize v).
> 
> This fixes following randconfig warning:
> FATAL: modpost: GPL-incompatible module palmas-pwrbutton.ko uses GPL-only symbol 'platform_driver_unregister'
> 
Uggh.. forgot to add:

Fixes: adff5962fdd2 ("Input: introduce palmas-pwrbutton")

> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> Reported thread http://marc.info/?l=linux-input&m=141080223209150&w=2
> 
>  drivers/input/misc/palmas-pwrbutton.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/misc/palmas-pwrbutton.c b/drivers/input/misc/palmas-pwrbutton.c
> index 3f90211..4ed6f78 100644
> --- a/drivers/input/misc/palmas-pwrbutton.c
> +++ b/drivers/input/misc/palmas-pwrbutton.c
> @@ -326,5 +326,5 @@ module_platform_driver(palmas_pwron_driver);
>  
>  MODULE_ALIAS("platform:palmas-pwrbutton");
>  MODULE_DESCRIPTION("Palmas Power Button");
> -MODULE_LICENSE("GPL V2");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Texas Instruments Inc.");
> 

-- 
Regards,
Nishanth Menon
