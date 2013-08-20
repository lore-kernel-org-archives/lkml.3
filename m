Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab3HTBZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 21:25:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:39164 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab3HTBZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 21:25:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,915,1367996400"; 
   d="scan'208";a="383400460"
Date: Tue, 20 Aug 2013 03:25:35 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: broonie@kernel.org, swarren@wwwdotorg.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, rob@landley.net,
        lee.jones@linaro.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, kishon@ti.com,
        j-keerthy@ti.com, ian.campbell@citrix.com
Subject: Re: [PATCH V2 2/3] mfd: palmas: add support for external control
 configuration
Message-ID: <20130820012535.GD13324@zurbaran>
References: <1376380392-19723-1-git-send-email-ldewangan@nvidia.com>
 <1376380392-19723-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376380392-19723-3-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Tue, Aug 13, 2013 at 01:23:11PM +0530, Laxman Dewangan wrote:
> Some of Palmas resources like clock, SMPSs, LDOs etc can be controlled
> by external pins ENABLE1, ENABLE2 or NSLEEP.
> 
> Add support to configure these resources to externally controlled.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> Fix typos: palams ->palmas
> 
>  drivers/mfd/palmas.c       |   97 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/palmas.h |   49 ++++++++++++++++++++++
>  2 files changed, 146 insertions(+), 0 deletions(-)
Applied with Lee's Ack.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
