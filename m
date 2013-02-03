Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3BCRBa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 12:01:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:58752 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3BCRB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 12:01:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="286033205"
Date: Sun, 3 Feb 2013 18:01:16 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, lrg@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] mfd/regulator: tps65090: add DT support and
 suspend/resume cleanups
Message-ID: <20130203170116.GK8476@sortiz-mobl>
References: <1356686981-4152-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356686981-4152-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Fri, Dec 28, 2012 at 02:59:37PM +0530, Laxman Dewangan wrote:
> The patch series add DT support on TPS65090 device.
> 
> Also remove the suspend/resume implementation as it duplicates with
> irq_suspend/irq_resume().
> 
> Laxman Dewangan (4):
>   mfd: tps65090: add DT support for tps65090
>   regulator: tps65090: add DT support
>   mfd: tps65090: Pass irq domain when adding mfd sub devices
>   mfd: tps65090: remove suspend/resume callbacks
> 
>  .../devicetree/bindings/regulator/tps65090.txt     |  121 ++++++++++++++++++++
>  drivers/mfd/tps65090.c                             |   77 ++++++++----
>  drivers/regulator/tps65090-regulator.c             |   96 +++++++++++++++-
>  include/linux/mfd/tps65090.h                       |    1 +
>  4 files changed, 266 insertions(+), 29 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/regulator/tps65090.txt
All 4 patches applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
