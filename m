Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbaIOVfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:35:37 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:56113 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbaIOVff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:35:35 -0400
Date: Mon, 15 Sep 2014 14:35:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: Jim Davis <jim.epost@gmail.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] Input: palmas-pwrbutton: Fix typo in License
Message-ID: <20140915213525.GA13468@core.coreip.homeip.net>
References: <1410803937-27022-1-git-send-email-nm@ti.com>
 <5417294C.2010506@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5417294C.2010506@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 01:00:44PM -0500, Nishanth Menon wrote:
> On 09/15/2014 12:58 PM, Nishanth Menon wrote:
> > Follow the license string convention indicated in include/linux/module.h
> > (don't capitalize v).
> > 
> > This fixes following randconfig warning:
> > FATAL: modpost: GPL-incompatible module palmas-pwrbutton.ko uses GPL-only symbol 'platform_driver_unregister'
> > 
> Uggh.. forgot to add:
> 
> Fixes: adff5962fdd2 ("Input: introduce palmas-pwrbutton")

Applied both, thank you.

> 
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Reported-by: Jim Davis <jim.epost@gmail.com>
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> > ---
> > Reported thread http://marc.info/?l=linux-input&m=141080223209150&w=2
> > 
> >  drivers/input/misc/palmas-pwrbutton.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/input/misc/palmas-pwrbutton.c b/drivers/input/misc/palmas-pwrbutton.c
> > index 3f90211..4ed6f78 100644
> > --- a/drivers/input/misc/palmas-pwrbutton.c
> > +++ b/drivers/input/misc/palmas-pwrbutton.c
> > @@ -326,5 +326,5 @@ module_platform_driver(palmas_pwron_driver);
> >  
> >  MODULE_ALIAS("platform:palmas-pwrbutton");
> >  MODULE_DESCRIPTION("Palmas Power Button");
> > -MODULE_LICENSE("GPL V2");
> > +MODULE_LICENSE("GPL v2");
> >  MODULE_AUTHOR("Texas Instruments Inc.");
> > 
> 
> -- 
> Regards,
> Nishanth Menon

-- 
Dmitry
