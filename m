Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965142Ab3FTIjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:39:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:60584 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935296Ab3FTIj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:39:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,903,1363158000"; 
   d="scan'208";a="356634536"
Date: Thu, 20 Jun 2013 10:39:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, broonie@kernel.org, ldewangan@nvidia.com,
        grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, gg@slimlogic.co.uk
Subject: Re: [PATCH v3 0/4] MFD: Palmas: Add TPS659038 PMIC support on Palmas
Message-ID: <20130620083913.GC15667@zurbaran>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 19, 2013 at 11:27:46AM +0530, Keerthy wrote:
> From: J Keerthy <j-keerthy@ti.com>
> 
> The Patch series adds TPS659038 PMIC support in the palmas MFD and Regulator
> drivers. The TPS659038 has almost the same registers as of the earlier
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
> The patch series is based on the patch:
>         http://www.mail-archive.com/linux-omap@vger.kernel.org/msg90598.html
> 
> V3:
> 
> Implements Interrupts check using i2c->irq variable instead of DT
> "interrupts" property.
> 
> Cleans ups in assiging the features variable in patch 2.
> 
> V2:
> 
> Implements Interrupts checking via DT instead of creating flags
> and checking based on chip ID.
> 
> J Keerthy (4):
>   MFD: Palmas: Check if irq is valid
>   MFD: Palmas: Add SMPS10_BOOST feature
>   mfd: Palmas: Add TPS659038 PMIC support
>   regulator: Palmas: Add TPS659038 support
I took the first 2 patches, but patch #3 does not apply.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
