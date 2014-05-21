Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaEULWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:22:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:62154 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaEULWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:22:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,879,1392192000"; 
   d="scan'208";a="434970007"
Date: Wed, 21 May 2014 16:36:37 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Christopher Freeman <cfreeman@nvidia.com>, ldewangan@nvidia.com,
        swarren@nvidia.com, dan.j.williams@intel.com,
        dmaengine@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] Tegra DMA residue improvements
Message-ID: <20140521110637.GQ21128@intel.com>
References: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com>
 <20140521055213.GK21128@intel.com>
 <537C4EAB.1040802@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537C4EAB.1040802@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 08:58:51AM +0200, Lars-Peter Clausen wrote:
> On 05/21/2014 07:52 AM, Vinod Koul wrote:
> >On Tue, May 06, 2014 at 02:22:20PM -0700, Christopher Freeman wrote:
> >>A collection of patches to improve Tegra's DMA residual reporting
> >>
> >>Christopher Freeman (3):
> >>   dma: tegra: finer granularity residual for tx_status
> >>   dma: tegra: change interrupt-related log levels
> >>   dma: tegra: avoid int overflow for transferred count
> >Can you pls use the *right* subsystem name...
> >
> 
> Without you saying what the right subsystem name is, I think it is
> not that obvious what it is:
ah... the subsystem name and ML name is dmaengine

> 
> git log --format="%s" --no-merges drivers/dma/ | grep '^[a-zA-Z]\+'
> -o | sort | uniq -c | sort -n
> 
> 381 dma
> 509 dmaengine
> 
> So there is a bias towards 'dmaengine', but if you only look at
> recent commits there is a bias towards 'dma'.
And thats what i am getting annoyed at :) Yes ppl please use dmaengine only
I think I will stop accepting patches with "dma" now and improve the stats
here...

-- 
~Vinod

> 
> git log v3.6..HEAD --format="%s" --no-merges drivers/dma/ | grep
> '^[a-zA-Z]\+' -o | sort | uniq -c | sort -n
> 
> 181 dmaengine
> 248 dma
> 
> - Lars
> 
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
