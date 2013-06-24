Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3FXLn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:43:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:10671 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab3FXLn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:43:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,928,1363158000"; 
   d="scan'208";a="354815723"
Date: Mon, 24 Jun 2013 13:43:22 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: J Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, broonie@kernel.org, ldewangan@nvidia.com,
        grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, gg@slimlogic.co.uk
Subject: Re: [PATCH 2/4] MFD: Palmas: Add TPS659038 PMIC support
Message-ID: <20130624114322.GB30838@zurbaran>
References: <1371726316-10078-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371726316-10078-1-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 20, 2013 at 04:35:16PM +0530, J Keerthy wrote:
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
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/mfd/palmas.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
