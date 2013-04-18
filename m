Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967266Ab3DRWgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 18:36:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:35606 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936545Ab3DRWgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 18:36:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,504,1363158000"; 
   d="scan'208";a="297182512"
Date: Fri, 19 Apr 2013 00:36:09 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>
Subject: Re: [PATCH 1/2] mfd: wm8994: Add device ID data to WM8994 OF device
 IDs
Message-ID: <20130418223609.GC8798@zurbaran>
References: <1365700312-7452-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365700312-7452-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Apr 11, 2013 at 06:11:50PM +0100, Mark Brown wrote:
> We can actually read this back from the device but we use this when
> registered using standard I2C board data registration so make sure
> it's there for OF too.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  drivers/mfd/wm8994-core.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
Both patches applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
