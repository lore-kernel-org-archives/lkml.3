Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbaKUR1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:27:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47086 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069AbaKUR1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:27:02 -0500
Date: Fri, 21 Nov 2014 12:26:52 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, David Vrabel <david.vrabel@citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] small swiotlb-xen fixes
Message-ID: <20141121172652.GF8314@laptop.dumpdata.com>
References: <alpine.DEB.2.02.1411211657430.2675@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1411211657430.2675@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 05:00:05PM +0000, Stefano Stabellini wrote:
> Hi all,
> I have a couple of small straightforward fixes for swiotlb-xen for 3.19.
> 

They look fine to me.

Thanks.
> Cheers,
> 
> Stefano
> 
> 
> Stefano Stabellini (2):
>       swiotlb-xen: call xen_dma_sync_single_for_device when appropriate
>       swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single
> 
>  drivers/xen/swiotlb-xen.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
