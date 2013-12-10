Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3LJNVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:21:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:59333 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab3LJNVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:21:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,865,1378882800"; 
   d="scan'208";a="422288633"
Date: Tue, 10 Dec 2013 17:52:24 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH V4] dma: add dma_get_any_slave_channel(), for use in
 of_xlate()
Message-ID: <20131210122224.GK29580@intel.com>
References: <1385494851-22640-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385494851-22640-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 12:40:51PM -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> mmp_pdma.c implements a custom of_xlate() function that is 95% identical
> to what Tegra will need. Create a function to implement the common part,
> so everyone doesn't just cut/paste the implementation.
Applied, to topic/of

--
~Vinod
