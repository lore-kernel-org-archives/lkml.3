Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3KATi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:38:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31485 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3KATi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:38:56 -0400
Date: Fri, 1 Nov 2013 15:37:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: linux-next: Tree for Oct 30 (include/xen/swiotlb-xen.h)
Message-ID: <20131101193720.GB15622@phenom.dumpdata.com>
References: <20131030184511.c90aa7f40fec6b2e1652f394@canb.auug.org.au>
 <527153A3.5020404@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527153A3.5020404@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 11:44:51AM -0700, Randy Dunlap wrote:
> On 10/30/13 00:45, Stephen Rothwell wrote:
> > Hi all,
> > 
> > News:  I am now doing an arm multi_v7_defconfig build between each merge.
> > 
> > Changes since 20131029:
> > 
> > The arm defconfig build is fixed again.
> > 
> > The net-next tree gained a conflict against the net tree.
> > 
> > The xen-tip tree gained a conflict against the arm tree.
> > 
> > The akpm-current tree gained a conflict against the tip tree and a build
> > failure for which I reverted 3 commits.
> > 
> > Various build problems from yesterday have been resolved.
> 
> on x86_64:

Stefano, please fix that.

> 
> In file included from include/xen/swiotlb-xen.h:4:0,
>                  from drivers/xen/grant-table.c:52:
> include/linux/swiotlb.h:45:13: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/linux/swiotlb.h:45:13: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> include/linux/swiotlb.h:49:28: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/linux/swiotlb.h:54:14: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/linux/swiotlb.h:68:15: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/linux/swiotlb.h:71:18: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/linux/swiotlb.h:75:14: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/linux/swiotlb.h:79:9: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/linux/swiotlb.h:83:44: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/linux/swiotlb.h:88:17: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/linux/swiotlb.h:92:26: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/linux/swiotlb.h:96:21: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/linux/swiotlb.h:100:29: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/linux/swiotlb.h:104:24: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> In file included from drivers/xen/grant-table.c:52:0:
> include/xen/swiotlb-xen.h:21:19: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/xen/swiotlb-xen.h:25:15: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/xen/swiotlb-xen.h:29:12: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/xen/swiotlb-xen.h:34:14: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/xen/swiotlb-xen.h:38:23: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/xen/swiotlb-xen.h:42:25: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/xen/swiotlb-xen.h:46:26: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> include/xen/swiotlb-xen.h:50:28: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
> 
> 
> 
> -- 
> ~Randy
