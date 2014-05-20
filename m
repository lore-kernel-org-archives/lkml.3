Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbaETI3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:29:38 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:53601 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaETI3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:29:36 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 20 May 2014 17:32:06 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Gioh Kim <gioh.kim@lge.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Heesub Shin <heesub.shin@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [RFC PATCH] arm: dma-mapping: fallback allocation for cma failure
Message-ID: <20140520083206.GA8927@js1304-P5Q-DELUXE>
References: <537AEEDB.2000001@lge.com>
 <20140520065222.GB8315@js1304-P5Q-DELUXE>
 <537AFED0.4010401@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537AFED0.4010401@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 04:05:52PM +0900, Gioh Kim wrote:
> That case, device-specific coherent memory allocation, is handled at dma_alloc_coherent in arm_dma_alloc.
> __dma_alloc handles only general coherent memory allocation.
> 
> I'm sorry missing mention about it.
> 

Hello,

AFAIK, *coherent* memory allocation is different with *contiguous* memory
allocation(CMA). So we need to handle the case I mentioned.

Thanks.
