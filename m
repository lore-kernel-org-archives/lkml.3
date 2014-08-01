Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaHAQyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:54:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:63894 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaHAQyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:54:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,780,1400050800"; 
   d="scan'208";a="552432913"
Date: Fri, 1 Aug 2014 22:15:24 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Vignesh Raman <Vignesh_Raman@mentor.com>
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiada_Wang@mentor.com
Subject: Re: [PATCH 2/2] dma: imx-sdma: Adding tasklet_kill() in
 sdma_remove function.
Message-ID: <20140801164524.GC8181@intel.com>
References: <1406725875-9171-1-git-send-email-Vignesh_Raman@mentor.com>
 <1406725875-9171-3-git-send-email-Vignesh_Raman@mentor.com>
 <20140731120205.GT8181@intel.com>
 <53DB9EFD.4040107@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DB9EFD.4040107@mentor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 07:36:53PM +0530, Vignesh Raman wrote:
> On Thursday 31 July 2014 05:32 PM, Vinod Koul wrote:
> > On Wed, Jul 30, 2014 at 06:41:15PM +0530, Vignesh Raman wrote:
> >> Several dma drivers calls tasklet_kill() in remove function. This is missing in
> >> imx driver, so adding tasklet_kill() in sdma_remove function.
> > And why should we do that ?
> > 
> This is done because all running tasklets should be killed on remove.

And what prevents is from mentioning this in changelog!

-- 
~Vinod
