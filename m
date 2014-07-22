Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbaGVQOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:14:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:39513 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337AbaGVQOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:14:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="577067743"
Date: Tue, 22 Jul 2014 21:39:08 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] dmaengine: pl330: Check if the DMA descriptor is
 NULL
Message-ID: <20140722160908.GA8181@intel.com>
References: <1405732907-30964-1-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405732907-30964-1-git-send-email-javier.martinez@collabora.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 03:21:47AM +0200, Javier Martinez Canillas wrote:
> Commit 6079d38 ("dmaengine: pl330: Remove useless xfer_cb indirection")
> removed the __callback() function which created an unnecessary level of
> indirection to execute the tranfer callback .xfer_cb
> 
> Unfortunately the commit also changed the semantics slightly since that
> function used to check if the request was not NULL before attempting to
> execute the callback function. Not checking this could lead to a kernel
> NULL pointer dereference error.

Applied, thanks

-- 
~Vinod
