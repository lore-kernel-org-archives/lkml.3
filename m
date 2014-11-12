Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaKLJYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:24:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:13784 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbaKLJYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:24:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,367,1413270000"; 
   d="scan'208";a="630664285"
Date: Wed, 12 Nov 2014 14:55:06 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>, stable@vger.kernel.org
Subject: Re: [PATCH] dmaengine: sun6i: Fix memcpy operation
Message-ID: <20141112092506.GA24582@intel.com>
References: <1415730952-1945-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415730952-1945-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 07:35:52PM +0100, Maxime Ripard wrote:
> The prep_memcpy call was not setting any meaningful burst and width because it
> was relying on the dma_slave_config was not set already.
> 
> Rework the needed conversion functions, and hardcode the width and burst to
> use.
>

Applied, thanks.

For memcpy, reying on dma_slave-config wasnt the right idea to start with.
Memcoy is supposed to work even without that

Thanks

-- 
~Vinod
