Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaGGKV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:21:27 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:5565 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaGGKVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:21:24 -0400
X-IronPort-AV: E=Sophos;i="5.01,617,1400025600"; 
   d="scan'208";a="150403961"
Date: Mon, 7 Jul 2014 11:20:39 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: fbdev: xen-fbfront.c:  Cleaning up useless
 assignment of function parameter
In-Reply-To: <1404667640-14855-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Message-ID: <alpine.DEB.2.02.1407071120310.27641@kaball.uk.xensource.com>
References: <1404667640-14855-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jul 2014, Rickard Strandqvist wrote:
> Remove assignment of function parameter, that has no effect outside the function
> 
> This was found using a static code analysis program called cppcheck
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  drivers/video/fbdev/xen-fbfront.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/video/fbdev/xen-fbfront.c b/drivers/video/fbdev/xen-fbfront.c
> index 901014b..e1207a1 100644
> --- a/drivers/video/fbdev/xen-fbfront.c
> +++ b/drivers/video/fbdev/xen-fbfront.c
> @@ -222,7 +222,6 @@ static int xenfb_setcolreg(unsigned regno, unsigned red, unsigned green,
>  	red = CNVT_TOHW(red, info->var.red.length);
>  	green = CNVT_TOHW(green, info->var.green.length);
>  	blue = CNVT_TOHW(blue, info->var.blue.length);
> -	transp = CNVT_TOHW(transp, info->var.transp.length);
>  #undef CNVT_TOHW
>  
>  	v = (red << info->var.red.offset) |
> -- 
> 1.7.10.4
> 
