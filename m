Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab3IBHUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:20:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:57083 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758142Ab3IBHUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:20:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1005,1367996400"; 
   d="scan'208";a="372117764"
Date: Mon, 2 Sep 2013 12:04:29 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        "'Simon Horman'" <horms+renesas@verge.net.au>,
        "'Guennadi Liakhovetski'" <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH 1/2] dma: sh: use devm_ioremap_resource() instead of
 devm_request_and_ioremap()
Message-ID: <20130902063429.GJ7376@intel.com>
References: <004c01cea77a$ffd30030$ff790090$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004c01cea77a$ffd30030$ff790090$%han@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 10:23:15AM +0900, Jingoo Han wrote:
> Use devm_ioremap_resource() because devm_request_and_ioremap() is
> obsoleted by devm_ioremap_resource().
Applied both, Thanks

~Vinod
