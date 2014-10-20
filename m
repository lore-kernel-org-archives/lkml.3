Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaJTMVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:21:10 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:10223 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaJTMVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:21:08 -0400
Message-ID: <5444FE2E.6030509@atmel.com>
Date: Mon, 20 Oct 2014 14:21:02 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] drivers: video: fbdev: atmel_lcdfb.c: remove unnecessary
 header
References: <1413548355-499-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1413548355-499-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/2014 14:19, Alexandre Belloni :
> Remove unnecessary mach/cpu.h header to be able to converge to a multiplatform
> kernel.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks.

Tomi, can you take it?

Bye,

> ---
>  drivers/video/fbdev/atmel_lcdfb.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/video/fbdev/atmel_lcdfb.c b/drivers/video/fbdev/atmel_lcdfb.c
> index 1d8bdb92939b..ea45a30fd4d2 100644
> --- a/drivers/video/fbdev/atmel_lcdfb.c
> +++ b/drivers/video/fbdev/atmel_lcdfb.c
> @@ -26,7 +26,6 @@
>  #include <video/of_display_timing.h>
>  #include <video/videomode.h>
>  
> -#include <mach/cpu.h>
>  #include <asm/gpio.h>
>  
>  #include <video/atmel_lcdc.h>
> 


-- 
Nicolas Ferre
