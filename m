Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965042Ab3FTI1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:27:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:13347 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964992Ab3FTI1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:27:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,903,1363158000"; 
   d="scan'208";a="356629679"
Date: Thu, 20 Jun 2013 10:27:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
Cc: tony@atomide.com, lgirdwood@gmail.com, broonie@kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        t-kristo@ti.com, gg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] MFD: Change TWL6025 references to TWL6032
Message-ID: <20130620082741.GB15667@zurbaran>
References: <1371644642-934-1-git-send-email-oleksandr.kozaruk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371644642-934-1-git-send-email-oleksandr.kozaruk@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleksandr,

On Wed, Jun 19, 2013 at 03:24:02PM +0300, Oleksandr Kozaruk wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
> 
> The TWL6025 was never released beyond sample form and was replaced by
> the PhoenixLite range of chips - TWL6032. Change the references to
> reference the TWL6032 class and name the registers to twl6032 in line with
> an actual released chip name to avoid confusion.
> 
> Currently there are no users of TWL6025 in the code.
> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> ---
> 
> There are non-mainline branches that use twl6032 by its name (for example
> git://git.omapzoom.org/kernel/omap.git). There is intention to add support
> of twl6032 device in mainline, but we'd like to know if we can use twl6032
> instead of twl6025 in our new patches, that we are going to provide.
> Related discussion: https://patchwork.kernel.org/patch/2686331/
> 
>  .../bindings/regulator/twl-regulator.txt           |   26 +++----
>  .../devicetree/bindings/usb/twlxxxx-usb.txt        |    2 +-
>  drivers/mfd/twl-core.c                             |   46 ++++++------
>  drivers/regulator/twl-regulator.c                  |   76 ++++++++++----------
>  drivers/usb/phy/phy-twl6030-usb.c                  |    2 +-
>  include/linux/i2c/twl.h                            |   30 ++++----
>  6 files changed, 91 insertions(+), 91 deletions(-)
Applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
