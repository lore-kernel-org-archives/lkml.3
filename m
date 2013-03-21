Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab3CUIic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:38:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:42278 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036Ab3CUIib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:38:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="282632435"
Date: Thu, 21 Mar 2013 13:43:28 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Dan Williams <djbw@fb.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH REPOST] dma: tegra: assume CONFIG_OF
Message-ID: <20130321081328.GH10326@intel.com>
References: <1363041026-31890-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363041026-31890-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 04:30:26PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Tegra only supports, and always enables, device tree. Remove all ifdefs
> and runtime checks for DT support from the driver.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
Applied thanks

--
~Vinod
