Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab3F0HsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:48:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:47864 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab3F0HsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:48:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="scan'208";a="260786744"
Date: Thu, 27 Jun 2013 09:47:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: J Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, broonie@kernel.org, ldewangan@nvidia.com,
        grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        gg@slimlogic.co.uk
Subject: Re: [PATCH 4/4] regulator: Palmas: Add TPS659038 support
Message-ID: <20130627074701.GB4576@zurbaran>
References: <1371726135-9891-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371726135-9891-1-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 20, 2013 at 04:32:15PM +0530, J Keerthy wrote:
> Add TPS659038 support.
> 
> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> Acked-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/regulator/palmas-regulator.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
Applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
