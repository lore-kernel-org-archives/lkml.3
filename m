Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbaIWNYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:24:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:34616 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbaIWNYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:24:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="390352174"
Date: Tue, 23 Sep 2014 18:23:27 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: dan.j.williams@intel.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 0/2] dmaengine: omap-dma: Fix cyclic suspend/resume
Message-ID: <20140923125327.GK24663@intel.com>
References: <1410896757-3848-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410896757-3848-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 10:45:55PM +0300, Peter Ujfalusi wrote:
> Hi,
> 
> Changes since v2:
> - fix typo in patch two
> - Acked-by added from Russell
> 
> When the audio is paused/resumed (application paused the sream or board suspend)
> the audio was only playing back one period worth of data and then stops because
> the omap_dam_stop() clears the link configuration and it is not restored in
> start.
> 
> Also add memory barrier call to resume path since this could happen right after
> coming out from suspend.

Applied, thanks

-- 
~Vinod

