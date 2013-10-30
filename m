Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3J3So4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:44:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51719 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab3J3Sox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:44:53 -0400
Message-ID: <527153A3.5020404@infradead.org>
Date: Wed, 30 Oct 2013 11:44:51 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org
Subject: Re: linux-next: Tree for Oct 30 (include/xen/swiotlb-xen.h)
References: <20131030184511.c90aa7f40fec6b2e1652f394@canb.auug.org.au>
In-Reply-To: <20131030184511.c90aa7f40fec6b2e1652f394@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/13 00:45, Stephen Rothwell wrote:
> Hi all,
> 
> News:  I am now doing an arm multi_v7_defconfig build between each merge.
> 
> Changes since 20131029:
> 
> The arm defconfig build is fixed again.
> 
> The net-next tree gained a conflict against the net tree.
> 
> The xen-tip tree gained a conflict against the arm tree.
> 
> The akpm-current tree gained a conflict against the tip tree and a build
> failure for which I reverted 3 commits.
> 
> Various build problems from yesterday have been resolved.

on x86_64:

In file included from include/xen/swiotlb-xen.h:4:0,
                 from drivers/xen/grant-table.c:52:
include/linux/swiotlb.h:45:13: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/linux/swiotlb.h:45:13: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
include/linux/swiotlb.h:49:28: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/linux/swiotlb.h:54:14: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/linux/swiotlb.h:68:15: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/linux/swiotlb.h:71:18: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/linux/swiotlb.h:75:14: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/linux/swiotlb.h:79:9: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/linux/swiotlb.h:83:44: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/linux/swiotlb.h:88:17: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/linux/swiotlb.h:92:26: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/linux/swiotlb.h:96:21: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/linux/swiotlb.h:100:29: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/linux/swiotlb.h:104:24: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
In file included from drivers/xen/grant-table.c:52:0:
include/xen/swiotlb-xen.h:21:19: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/xen/swiotlb-xen.h:25:15: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/xen/swiotlb-xen.h:29:12: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/xen/swiotlb-xen.h:34:14: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/xen/swiotlb-xen.h:38:23: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/xen/swiotlb-xen.h:42:25: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/xen/swiotlb-xen.h:46:26: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]
include/xen/swiotlb-xen.h:50:28: warning: 'enum dma_data_direction' declared inside parameter list [enabled by default]



-- 
~Randy
