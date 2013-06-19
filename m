Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3FSIYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:24:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:39941 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab3FSIXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:23:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,895,1363158000"; 
   d="scan'208";a="257108074"
Date: Wed, 19 Jun 2013 10:23:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Kevin Hilman <khilman@linaro.org>, Rob Landley <rob@landley.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tero Kristo <t-kristo@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mfd: twl4030-power: Start DT conversion and
 updates
Message-ID: <20130619082348.GQ7161@zurbaran>
References: <1371561480-28325-1-git-send-email-florian.vaussard@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371561480-28325-1-git-send-email-florian.vaussard@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On Tue, Jun 18, 2013 at 03:17:55PM +0200, Florian Vaussard wrote:
> Hello,
> 
> This series enables a partial DT support for twl4030-power. The
> missing part is the power management scripts, as the required
> binding should be defined first. It however enables the complete
> shutdown of the processor at poweroff when booting with DT,
> dropping the power consumption from around 350 mA on Overo+Tobi
> to about 40 mA.
> 
> The poweroff callback was tested with both DT and non-DT boots.
> 
> The last two patches simplify the error path in the probe function,
> and fix registers relocking on error.
> 
> Best regards,
> 
> Florian
> 
> Since v1:
> - use module_platform_driver()
> - split the refactoring of the probe function into a dedicated patch
> - new patch to fix registers relocking on error
> - rebased on mfd-next
> 
> 
> Florian Vaussard (5):
>   mfd: twl4030-power: Split from twl-core into a dedicated module
>   mfd: twl4030-power: Simplify probing of power scripts and resources
>   mfd: twl4030-power: Start transition to DT
>   mfd: twl4030-power: Simplify error path
>   mfd: twl4030-power: Fix relocking on error
All 5 patches applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
