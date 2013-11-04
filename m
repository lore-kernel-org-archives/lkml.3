Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3KDS12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:27:28 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25241 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab3KDS11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:27:27 -0500
Date: Mon, 4 Nov 2013 13:25:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: linux-next: Tree for Oct 30 (include/xen/swiotlb-xen.h)
Message-ID: <20131104182550.GB7345@phenom.dumpdata.com>
References: <20131030184511.c90aa7f40fec6b2e1652f394@canb.auug.org.au>
 <527153A3.5020404@infradead.org>
 <20131101193720.GB15622@phenom.dumpdata.com>
 <alpine.DEB.2.02.1311041801470.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311041801470.26077@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 06:14:26PM +0000, Stefano Stabellini wrote:
> On Fri, 1 Nov 2013, Konrad Rzeszutek Wilk wrote:
> > On Wed, Oct 30, 2013 at 11:44:51AM -0700, Randy Dunlap wrote:
> > > On 10/30/13 00:45, Stephen Rothwell wrote:
> > > > Hi all,
> > > > 
> > > > News:  I am now doing an arm multi_v7_defconfig build between each merge.
> > > > 
> > > > Changes since 20131029:
> > > > 
> > > > The arm defconfig build is fixed again.
> > > > 
> > > > The net-next tree gained a conflict against the net tree.
> > > > 
> > > > The xen-tip tree gained a conflict against the arm tree.
> > > > 
> > > > The akpm-current tree gained a conflict against the tip tree and a build
> > > > failure for which I reverted 3 commits.
> > > > 
> > > > Various build problems from yesterday have been resolved.
> > > 
> > > on x86_64:
> > 
> > Stefano, please fix that.
>  
> Thanks for the notification. I am appending the fix that I am about to
> apply to xentip/linux-next.
> 

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> commit bb5ebdb6a674c59cd7b5d159d6ca3c0084ee60e1
> Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Date:   Mon Nov 4 17:54:27 2013 +0000
> 
>     swiotlb-xen: missing include dma-direction.h
>     
>     Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> diff --git a/include/xen/swiotlb-xen.h b/include/xen/swiotlb-xen.h
> index 7b64465..8b2eb93 100644
> --- a/include/xen/swiotlb-xen.h
> +++ b/include/xen/swiotlb-xen.h
> @@ -1,6 +1,7 @@
>  #ifndef __LINUX_SWIOTLB_XEN_H
>  #define __LINUX_SWIOTLB_XEN_H
>  
> +#include <linux/dma-direction.h>
>  #include <linux/swiotlb.h>
>  
>  extern int xen_swiotlb_init(int verbose, bool early);
