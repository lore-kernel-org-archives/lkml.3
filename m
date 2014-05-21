Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaEUGHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 02:07:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:59977 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaEUGHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 02:07:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,878,1392192000"; 
   d="scan'208";a="544046003"
Date: Wed, 21 May 2014 11:22:13 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Christopher Freeman <cfreeman@nvidia.com>
Cc: ldewangan@nvidia.com, swarren@nvidia.com, dan.j.williams@intel.com,
        dmaengine@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] Tegra DMA residue improvements
Message-ID: <20140521055213.GK21128@intel.com>
References: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 02:22:20PM -0700, Christopher Freeman wrote:
> A collection of patches to improve Tegra's DMA residual reporting
> 
> Christopher Freeman (3):
>   dma: tegra: finer granularity residual for tx_status
>   dma: tegra: change interrupt-related log levels
>   dma: tegra: avoid int overflow for transferred count
Can you pls use the *right* subsystem name...

-- 
~Vinod
