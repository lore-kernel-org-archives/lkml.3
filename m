Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbaKULGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:06:10 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:55777 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbaKULGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:06:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Keerthy <j-keerthy@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the arm-soc tree
Date: Fri, 21 Nov 2014 12:05:56 +0100
Message-ID: <5291580.tnIkyRiF2h@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141121164131.0190e0ab@canb.auug.org.au>
References: <20141121164131.0190e0ab@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ofCbzHeXnjNva8srEa1plIk7SCNiNCU28KWvVM814Ww
 DOD9pBP4zcPETVHgtdHfxGRDNUxsslyPIyUxWXwiJ/1d8dV5cD
 KqpNFDBwAXy45TZ+Pt+7Qdst4W/5PrRm3FJcptP3CqoDAAILrH
 1J7LM4wC3boQePM2tX4yddMGCT836USoje3iT3mq17q+L9wjxg
 UAAtAXuVJ1xtah8XKxl3k3+YDrzqrSPix8mFx8AOqtj6lY1Zip
 26eboe7WiK9tnUG+LFkzj1JLGwUQmMGYd3BxL7cdvvbsGRf5w6
 6fYfinwzV9+NOtli3S1iv6xb8gb4gFWf9pxk562gR00355rQiR
 D0knBX1ywhc3eBO8F1AY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2014 16:41:31 Stephen Rothwell wrote:
> --- a/drivers/bus/omap_l3_noc.c
> +++ b/drivers/bus/omap_l3_noc.c
> @@@ -358,8 -300,6 +358,7 @@@ static struct platform_driver omap_l3_d
>         .probe          = omap_l3_probe,
>         .driver         = {
>                 .name           = "omap_l3_noc",
> -               .owner          = THIS_MODULE,
>  +              .pm             = L3_DEV_PM_OPS,
>                 .of_match_table = of_match_ptr(l3_noc_match),
>         },
>   };
> 

Thanks, looks good.

	Arnd
