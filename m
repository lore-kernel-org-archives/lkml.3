Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab3HMMJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:09:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:49597 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757641Ab3HMMJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:09:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,868,1367996400"; 
   d="scan'208";a="380193741"
Date: Tue, 13 Aug 2013 16:57:04 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/35] dma: use dev_get_platdata()
Message-ID: <20130813112704.GD32147@intel.com>
References: <004201ce8cfc$12990af0$37cb20d0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004201ce8cfc$12990af0$37cb20d0$@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 05:09:11PM +0900, Jingoo Han wrote:
> Use the wrapper function for retrieving the platform data instead of
> accessing dev->platform_data directly.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Applied, Thanks

~Vinod
