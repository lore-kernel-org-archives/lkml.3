Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3AUFQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 00:16:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:60549 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab3AUFQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 00:16:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,504,1355126400"; 
   d="scan'208";a="246343578"
Date: Sun, 20 Jan 2013 20:51:28 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH] dw_dmac: move soft LLP code from tasklet to
 dwc_scan_descriptors
Message-ID: <20130121045128.GE21551@intel.com>
References: <1358511255-6324-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358511255-6324-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 02:14:15PM +0200, Andy Shevchenko wrote:
> The proper place for the main logic of the soft LLP mode is
> dwc_scan_descriptors. It prevents to get the transfer unexpectedly aborted in
> case the user calls dwc_tx_status.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Applied, Thanks

--
~Vinod
