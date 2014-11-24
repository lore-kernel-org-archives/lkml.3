Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaKXL5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:57:51 -0500
Received: from smtp.citrix.com ([66.165.176.89]:11159 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbaKXL5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:57:49 -0500
X-IronPort-AV: E=Sophos;i="5.07,448,1413244800"; 
   d="scan'208";a="195195543"
Date: Mon, 24 Nov 2014 11:57:14 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] small swiotlb-xen fixes
In-Reply-To: <20141121172652.GF8314@laptop.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1411241157020.2675@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411211657430.2675@kaball.uk.xensource.com> <20141121172652.GF8314@laptop.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Konrad Rzeszutek Wilk wrote:
> On Fri, Nov 21, 2014 at 05:00:05PM +0000, Stefano Stabellini wrote:
> > Hi all,
> > I have a couple of small straightforward fixes for swiotlb-xen for 3.19.
> > 
> 
> They look fine to me.

Applied to devel/for-linus-3.19



> Thanks.
> > Cheers,
> > 
> > Stefano
> > 
> > 
> > Stefano Stabellini (2):
> >       swiotlb-xen: call xen_dma_sync_single_for_device when appropriate
> >       swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single
> > 
> >  drivers/xen/swiotlb-xen.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
