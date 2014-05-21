Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033AbaEUG1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 02:27:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:1182 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaEUG1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 02:27:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,878,1392192000"; 
   d="scan'208";a="434868361"
Date: Wed, 21 May 2014 11:41:25 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, dmaengine@vger.kernel.org
Subject: Re: [PATCH 1/2] dmaengine: omap: hide filter_fn for built-in
 drivers
Message-ID: <20140521061125.GN21128@intel.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 04:56:12PM +0200, Arnd Bergmann wrote:
> It is not possible to reference the omap_dma_filter_fn filter
> function from a built-in driver if the dmaengine driver itself
> is a loadable module, which is a valid configuration otherwise.
> 
> This provides only the dummy alternative if the function
> is referenced by a built-in driver to allow a successful
> build. The filter function is only required by ATAGS based
> platforms, which will continue to be broken after this change
> for the bogus configuration. When booting from DT, with the
> dma channels correctly listed there, it will work fine.

Applied, both thanks

-- 
~Vinod

