Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaEZPeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:34:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbaEZPeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:34:04 -0400
Date: Mon, 26 May 2014 17:34:01 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] gpio: pch: include linux/slab.h
Message-ID: <20140526173401.770af4a9@endymion.delvare>
In-Reply-To: <8665687.jWqf6bo4lM@wuerfel>
References: <8665687.jWqf6bo4lM@wuerfel>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2014 17:04:24 +0200, Arnd Bergmann wrote:
> The gpio-pch driver was recently enabled for compile-tests,
> which revealed that it is missing an include for linux/slab.h,
> which on ARM is not implied by any of the other headers.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
> index 83a1563..d6eac9b 100644
> --- a/drivers/gpio/gpio-pch.c
> +++ b/drivers/gpio/gpio-pch.c
> @@ -20,6 +20,7 @@
>  #include <linux/gpio.h>
>  #include <linux/interrupt.h>
>  #include <linux/irq.h>
> +#include <linux/slab.h>
>  
>  #define PCH_EDGE_FALLING	0
>  #define PCH_EDGE_RISING		BIT(0)
> 

Good catch, thanks Arnd.

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
SUSE L3 Support
