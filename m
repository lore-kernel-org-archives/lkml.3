Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3LUK0X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:26:23 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:46677 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab3LUK0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:26:22 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 21 Dec 2013 02:26:10 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Teddy Wang <teddy.wang@siliconmotion.com.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Huewe <peterhuewe@gmx.de>, Martin Berglund <martin@rogsta.net>,
        Ebru Akagunduz <ebru.akagunduz@gmail.com>,
        Javier =?iso-8859-1?Q?Mu=F1oz?= <jmunhoz@igalia.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] drivers: sm7xxfb: Mark function as static in sm7xxfb.c
Message-ID: <20131221102610.GA3611@leaf>
References: <20131221101413.GA2946@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131221101413.GA2946@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 03:44:13PM +0530, Rashika Kheria wrote:
> Mark function smtcfb_setmode() as static in sm7xxfb.c because it is not
> used outside this file.
> 
> This eliminates the following warning in sm7xxfb.c:
> drivers/staging/sm7xxfb/sm7xxfb.c:588:6: warning: no previous prototype for ‘smtcfb_setmode’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

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
> -- 
> 1.7.9.5
> 
