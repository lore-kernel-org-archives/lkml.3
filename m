Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab3AOBJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 20:09:22 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39956 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab3AOBJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 20:09:21 -0500
Date: Tue, 15 Jan 2013 09:09:20 +0800
From: Wang YanQing <udknight@gmail.com>
To: joro@8bytes.org
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com
Subject: Re: [PATCH]iommu: Include linux/err.h
Message-ID: <20130115010920.GA3406@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, joro@8bytes.org,
	joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
	alex.williamson@redhat.com
References: <20121213165539.GA10948@udknight>
 <1355418938.2229.13.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355418938.2229.13.camel@ul30vt.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 10:15:38AM -0700, Alex Williamson wrote:
> On Fri, 2012-12-14 at 00:55 +0800, Wang YanQing wrote:
> > The linux/iommu.h header uses ERR_PTR defined
> > in linux/err.h but doesn't include it.
> > 
> > Signed-off-by: Wang YanQing <udknight@gmail.com>
> > ---
> >  include/linux/iommu.h | 1 +
> >  1 file changed, 1 insertion(+)
> 
> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> 
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > index f3b99e1..f4a49a6 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -20,6 +20,7 @@
> >  #define __LINUX_IOMMU_H
> >  
> >  #include <linux/errno.h>
> > +#include <linux/err.h>
> >  #include <linux/types.h>
> >  
> >  #define IOMMU_READ	(1)
> 
> 
Hi Joerg Roedel, maybe you are saturated by
Emails, and miss it.

Thanks
