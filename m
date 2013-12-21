Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3LUMgI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 07:36:08 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:31666 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab3LUMgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 07:36:06 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Dec 2013 07:36:06 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhAFACaItVJbdWOb/2dsb2JhbABYgwuEDrY9gRIWdIIlAQEBBCMECwFGEAsYAgIFIQICDwIQNgYNAQUCAodsAxUBsR6TAA2GUheBKYtpgS9kB4JugUgBA5YrgWyMWoU6gy6BZw
X-IPAS-Result: AhAFACaItVJbdWOb/2dsb2JhbABYgwuEDrY9gRIWdIIlAQEBBCMECwFGEAsYAgIFIQICDwIQNgYNAQUCAodsAxUBsR6TAA2GUheBKYtpgS9kB4JugUgBA5YrgWyMWoU6gy6BZw
X-IronPort-AV: E=Sophos;i="4.95,527,1384297200"; 
   d="scan'208";a="133241931"
Message-ID: <52B58911.30707@igalia.com>
Date: Sat, 21 Dec 2013 13:26:57 +0100
From: =?UTF-8?B?SmF2aWVyIE11w7Fveg==?= <jmunhoz@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>
CC: linux-kernel@vger.kernel.org, Teddy Wang <teddy.wang@siliconmotion.com.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Huewe <peterhuewe@gmx.de>, Martin Berglund <martin@rogsta.net>,
        Ebru Akagunduz <ebru.akagunduz@gmail.com>, devel@driverdev.osuosl.org,
        josh@joshtriplett.org
Subject: Re: [PATCH] drivers: sm7xxfb: Mark function as static in sm7xxfb.c
References: <20131221101413.GA2946@rashika>
In-Reply-To: <20131221101413.GA2946@rashika>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2013 11:14 AM, Rashika Kheria wrote:
> Mark function smtcfb_setmode() as static in sm7xxfb.c because it is not
> used outside this file.
> 
> This eliminates the following warning in sm7xxfb.c:
> drivers/staging/sm7xxfb/sm7xxfb.c:588:6: warning: no previous prototype for ‘smtcfb_setmode’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Acked-by: Javier M. Mellid <jmunhoz@igalia.com>

> ---
>  drivers/staging/sm7xxfb/sm7xxfb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
> index ba199ff..f08b216 100644
> --- a/drivers/staging/sm7xxfb/sm7xxfb.c
> +++ b/drivers/staging/sm7xxfb/sm7xxfb.c
> @@ -585,7 +585,7 @@ static void smtc_set_timing(struct smtcfb_info *sfb)
>  	}
>  }
>  
> -void smtcfb_setmode(struct smtcfb_info *sfb)
> +static void smtcfb_setmode(struct smtcfb_info *sfb)
>  {
>  	switch (sfb->fb.var.bits_per_pixel) {
>  	case 32:
> 

