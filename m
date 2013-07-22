Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab3GVKDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:03:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:16847 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab3GVKDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:03:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,718,1367996400"; 
   d="scan'208";a="374460939"
Date: Mon, 22 Jul 2013 14:54:46 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: djbw@fb.com, yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pch_dma: fix error return code in pch_dma_probe()
Message-ID: <20130722092446.GC18642@intel.com>
References: <CAPgLHd-T4sgoLn2nXFYjz+5cMvQgrnaxQ=GsWPYHyDo8p1uyzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-T4sgoLn2nXFYjz+5cMvQgrnaxQ=GsWPYHyDo8p1uyzw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 08:34:59AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -ENODEV when no proper base address found error
> handling case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied, thanks

~Vinod
