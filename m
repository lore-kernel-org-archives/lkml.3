Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3G2G3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 02:29:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:1778 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab3G2G3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 02:29:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,767,1367996400"; 
   d="scan'208";a="274648096"
Date: Mon, 29 Jul 2013 11:20:24 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Xiang Wang <wangxfdu@gmail.com>
Cc: Dan Williams <djbw@fb.com>, linux-kernel@vger.kernel.org,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Subject: Re: [PATCH V3 0/2] dma: mmp_pdma: Fix phy channels not protected
 issue
Message-ID: <20130729055024.GD29095@intel.com>
References: <1371538559-13185-1-git-send-email-wangxfdu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371538559-13185-1-git-send-email-wangxfdu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 02:55:57PM +0800, Xiang Wang wrote:
> From: Xiang Wang <wangx@marvell.com>
> 
> This patch set deals with the issues that 1) phy channels are not protected
> in mmp_pdma. 2) dma request<->channel mapping is not cleared when a phy chan
> is freed.
Applied, thanks

~Vinod
