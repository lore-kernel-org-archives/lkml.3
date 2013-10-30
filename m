Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3J3Vhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:37:51 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:57505 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3J3Vht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:37:49 -0400
Date: Wed, 30 Oct 2013 17:37:41 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, linux-mtd@lists.infradead.org,
        yongjun_wei@trendmicro.com.cn, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] mtd: remove duplicated include from mtdcore.c
Message-ID: <20131030213741.GA20059@norris.computersforpeace.net>
References: <CAPgLHd8=fLjqnKEoTB2C+7R=Nz7bdV0D5ttO29em=P8nX-Tvag@mail.gmail.com>
 <20131030095640.GC2453@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030095640.GC2453@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 06:56:41AM -0300, Ezequiel Garcia wrote:
> On Wed, Oct 30, 2013 at 01:34:22PM +0800, Wei Yongjun wrote:
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > 
> > Remove duplicated include.
> > 
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > ---
> >  drivers/mtd/mtdcore.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> > index 7189089..92311a5 100644
> > --- a/drivers/mtd/mtdcore.c
> > +++ b/drivers/mtd/mtdcore.c
> > @@ -37,7 +37,6 @@
> >  #include <linux/backing-dev.h>
> >  #include <linux/gfp.h>
> >  #include <linux/slab.h>
> > -#include <linux/major.h>
> >  
> >  #include <linux/mtd/mtd.h>
> >  #include <linux/mtd/partitions.h>
> > 
> > 
> 
> Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Pushed to l2-mtd.git, thanks Wei! It probably could just be squashed
into the original patch, but I'm not sure it's actually worth the
rebase.

Brian
