Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab3HMMHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:07:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:59181 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757591Ab3HMMHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:07:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,868,1367996400"; 
   d="scan'208";a="361928392"
Date: Tue, 13 Aug 2013 16:55:05 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Dan Williams'" <djbw@fb.com>, "'Xiang Wang'" <wangx@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] dma: mmp_pdma: Staticize
 mmp_pdma_alloc_descriptor()
Message-ID: <20130813112505.GC32147@intel.com>
References: <000001ce9290$a25a83f0$e70f8bd0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001ce9290$a25a83f0$e70f8bd0$@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 07:35:13PM +0900, Jingoo Han wrote:
> mmp_pdma_alloc_descriptor() is used only in this file.
> Fix the following sparse warning:
> 
> drivers/dma/mmp_pdma.c:359:25: warning: symbol 'mmp_pdma_alloc_descriptor' was not declared. Should it be static?
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Applied all three, thanks

~Vinod
