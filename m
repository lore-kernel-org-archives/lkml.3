Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaJPKGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:06:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:62710 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbaJPKGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:06:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,731,1406617200"; 
   d="scan'208";a="615439897"
Date: Thu, 16 Oct 2014 13:06:48 +0300
From: Mika Westerberg <mika.westerberg@intel.com>
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Denis Turischev <denis.turischev@compulab.co.il>
Subject: Re: [PATCHv3 2/3] gpio: sch: Add support for Intel Quark X1000 SoC
Message-ID: <20141016100648.GB2255@lahna.fi.intel.com>
References: <1413431475-12799-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1413431475-12799-3-git-send-email-rebecca.swee.fun.chang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413431475-12799-3-git-send-email-rebecca.swee.fun.chang@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 11:51:14AM +0800, Chang Rebecca Swee Fun wrote:
> Intel Quark X1000 provides a total of 16 GPIOs. The GPIOs are split between
> the legacy I/O bridge and the GPIO controller.
> 
> GPIO-SCH is the GPIO pins on legacy bridge for Intel Quark SoC.
> Intel Quark X1000 has 2 GPIOs powered by the core power well and 6 from
> the suspend power well.
> 
> This piece of work is derived from Dan O'Donovan's initial work for Quark
> X1000 enabling.
> 
> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
