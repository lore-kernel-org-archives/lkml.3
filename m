Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab3IBLcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 07:32:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:32751 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365Ab3IBLcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 07:32:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1006,1367996400"; 
   d="scan'208";a="389914331"
Date: Mon, 2 Sep 2013 16:16:27 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, djbw@fb.com,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/1] dma: imx-dma: Remove redundant NULL check
Message-ID: <20130902104627.GN7376@intel.com>
References: <1378108278-4051-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378108278-4051-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 01:21:18PM +0530, Sachin Kamat wrote:
> kfree on a NULL pointer is a no-op. Null pointer check is
> not necessary.

Applied, thanks

~Vinod
