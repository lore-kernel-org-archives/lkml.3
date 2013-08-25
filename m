Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab3HYIUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 04:20:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:53734 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110Ab3HYIU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 04:20:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,950,1367996400"; 
   d="scan'208";a="286439737"
Date: Sun, 25 Aug 2013 13:06:01 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] DMA: shdma: make a pointer const
Message-ID: <20130825073601.GE8091@intel.com>
References: <Pine.LNX.4.64.1308021610240.28012@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1308021610240.28012@axis700.grange>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 04:18:09PM +0200, Guennadi Liakhovetski wrote:
> Platform data shouldn't be changed at run-time, so, pointers to it should
> be const.
Applied, thanks

~Vinod
