Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965209Ab3FTIly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:41:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:19561 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965049Ab3FTIlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:41:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,903,1363158000"; 
   d="scan'208";a="319895393"
Date: Thu, 20 Jun 2013 10:41:45 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, broonie@kernel.org, ldewangan@nvidia.com,
        grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, gg@slimlogic.co.uk
Subject: Re: [PATCH v3 3/4] mfd: Palmas: Add TPS659038 PMIC support
Message-ID: <20130620084145.GD15667@zurbaran>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
 <1371621470-22279-4-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371621470-22279-4-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 19, 2013 at 11:27:49AM +0530, Keerthy wrote:
> From: J Keerthy <j-keerthy@ti.com>
> 
> The Patch adds TPS659038 PMIC support in the palmas mfd driver.
> The TPS659038 has almost the same registers as of the earlier
> supported variants of PALMAS family such as the TWL6035.
> 
> The critical differences between TPS659038 and TWL6035 being:
> 
> 1) TPS659038 has nothing related to battery charging and back up battery stuff.
> 2) TPS659038 does not have does not have SMPS10(Boost) step up convertor.
> 3) TPS659038 does not have Battery detection and anything related to battery.
> 4) SD card detection, Battery presence detection, Vibrator, USB OTG are missing
>    when compared to TWL6035.
> 
> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> ---
>  Documentation/devicetree/bindings/mfd/palmas.txt |    2 ++
>  drivers/mfd/palmas.c                             |    5 +++++
>  2 files changed, 7 insertions(+), 0 deletions(-)
This one does not apply against mfd-next as I don't have the palmas.txt.
For Grant to take this one:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

If that creates conflicts (I already have a few palmas.c changes) then
we'll have to find a way to fix them (Me taking the bindings file ?).

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
