Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaKFM6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:58:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:39012 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbaKFM6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:58:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,325,1413270000"; 
   d="scan'208";a="632603260"
Date: Thu, 6 Nov 2014 18:28:52 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] dmaengine: pl330: Correct device assignment.
Message-ID: <20141106125852.GB1870@intel.com>
References: <545B5E03.3040809@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545B5E03.3040809@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 11:39:47AM +0000, Andrew Jackson wrote:
> Commit f6f2421c0a1c removed pl330_info structure by embedding it into
> pl330_dmac structure, but did not ensure that the dmac->ddma.dev
> pointer gets initialised before use. When dma_alloc_coherent() gets
> called on arm64 a WARN() gets triggered due to dev being NULL.

Applied, thanks

-- 
~Vinod

