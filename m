Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaGHR2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:28:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30021 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbaGHR2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:28:06 -0400
Date: Tue, 8 Jul 2014 11:08:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: fbdev: xen-fbfront.c:  Cleaning up useless
 assignment of function parameter
Message-ID: <20140708150812.GC2863@laptop.dumpdata.com>
References: <1404667640-14855-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <alpine.DEB.2.02.1407071120310.27641@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407071120310.27641@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 11:20:39AM +0100, Stefano Stabellini wrote:
> On Sun, 6 Jul 2014, Rickard Strandqvist wrote:
> > Remove assignment of function parameter, that has no effect outside the function
> > 
> > This was found using a static code analysis program called cppcheck
> > 
> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> 
> Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

and Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> 
> >  drivers/video/fbdev/xen-fbfront.c |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/video/fbdev/xen-fbfront.c b/drivers/video/fbdev/xen-fbfront.c
> > index 901014b..e1207a1 100644
> > --- a/drivers/video/fbdev/xen-fbfront.c
> > +++ b/drivers/video/fbdev/xen-fbfront.c
> > @@ -222,7 +222,6 @@ static int xenfb_setcolreg(unsigned regno, unsigned red, unsigned green,
> >  	red = CNVT_TOHW(red, info->var.red.length);
> >  	green = CNVT_TOHW(green, info->var.green.length);
> >  	blue = CNVT_TOHW(blue, info->var.blue.length);
> > -	transp = CNVT_TOHW(transp, info->var.transp.length);
> >  #undef CNVT_TOHW
> >  
> >  	v = (red << info->var.red.offset) |
> > -- 
> > 1.7.10.4
> > 
