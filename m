Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751115AbaKFGGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 01:06:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:32772 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaKFGGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 01:06:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,324,1413270000"; 
   d="scan'208";a="627466715"
Date: Thu, 6 Nov 2014 11:36:53 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] dmaengine: Cleanup chancnt
Message-ID: <20141106060653.GT1870@intel.com>
References: <1413450063-23829-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413450063-23829-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 11:00:52AM +0200, Maxime Ripard wrote:
> Hi everyone,
> 
> As pointed out in the documentation thread [1], the chancnt variable
> is filled during the driver registration in dma_async_device_register,
> from the liste of channels that has been set.
> 
> This serie removes the occurences of the drivers that set it in their
> probe function.

Applied all, thanks

-- 
~Vinod

