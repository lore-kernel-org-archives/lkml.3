Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaF1Mwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 08:52:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:52235 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbaF1Mww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 08:52:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,567,1400050800"; 
   d="scan'208";a="451100497"
Date: Sat, 28 Jun 2014 08:52:50 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH -next 04/26] block: Use dma_zalloc_coherent
Message-ID: <20140628125250.GT12025@linux.intel.com>
References: <cover.1402863904.git.joe@perches.com>
 <ff8b612a77e9c4d5826df68b3e6fe27b800610e9.1402863905.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff8b612a77e9c4d5826df68b3e6fe27b800610e9.1402863905.git.joe@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 01:37:33PM -0700, Joe Perches wrote:
> Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Applied
