Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab3COWYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 18:24:18 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53574 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab3COWYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 18:24:16 -0400
Message-ID: <5143A0F9.1010301@gmail.com>
Date: Sat, 16 Mar 2013 09:30:17 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        stable@vger.kernel.org, FlorianSchandinat@gmx.de,
        damien.cassou@lifl.fr
Subject: Re: [PATCH] video: ep93xx_fb: include <linux/io.h> for devm_ioremap()
References: <201303151520.26873.hartleys@visionengravers.com>
In-Reply-To: <201303151520.26873.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/03/13 09:20, H Hartley Sweeten wrote:

> commit be867814 "drivers/video/ep93xx-fb.c: use devm_ functions"
> 
> Introduced a build error:
> 
> drivers/video/ep93xx-fb.c: In function 'ep93xxfb_probe':
> drivers/video/ep93xx-fb.c:532: error: implicit declaration of function 'devm_ioremap'
> drivers/video/ep93xx-fb.c:533: warning: assignment makes pointer from integer without a cast
> 
> Include <linux/io.h> to pickup the declaration of 'devm_ioremap'.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: <stable@vger.kernel.org>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Damien Cassou <damien.cassou@lifl.fr>

Acked-by: Ryan Mallon <rmallon@gmail.com>

> ---
>  drivers/video/ep93xx-fb.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/video/ep93xx-fb.c b/drivers/video/ep93xx-fb.c
> index 3f2519d..e06cd5d 100644
> --- a/drivers/video/ep93xx-fb.c
> +++ b/drivers/video/ep93xx-fb.c
> @@ -23,6 +23,7 @@
>  #include <linux/slab.h>
>  #include <linux/clk.h>
>  #include <linux/fb.h>
> +#include <linux/io.h>
>  
>  #include <linux/platform_data/video-ep93xx.h>
>  


