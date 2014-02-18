Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbaBRLcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 06:32:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:12534 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbaBRLcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 06:32:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,501,1389772800"; 
   d="scan'208";a="476980553"
Date: Tue, 18 Feb 2014 16:59:24 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jingchang Lu <b35083@freescale.com>
Cc: dan.j.williams@intel.com, arnd@arndb.de, shawn.guo@linaro.org,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org,
        Alison Wang <b18965@freescale.com>
Subject: Re: [PATCH RESEND v11 2/2] dma: Add Freescale eDMA engine driver
 support
Message-ID: <20140218112924.GF10628@intel.com>
References: <1392689832-17011-1-git-send-email-b35083@freescale.com>
 <1392689832-17011-3-git-send-email-b35083@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392689832-17011-3-git-send-email-b35083@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 10:17:12AM +0800, Jingchang Lu wrote:
> Add Freescale enhanced direct memory(eDMA) controller support.
> This module can be found on Vybrid and LS-1 SoCs.
> 
> Signed-off-by: Alison Wang <b18965@freescale.com>
> Signed-off-by: Jingchang Lu <b35083@freescale.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks

-- 
~Vinod

