Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaHSPja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:39:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:63901 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbaHSPj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:39:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,895,1400050800"; 
   d="scan'208";a="578814689"
Date: Tue, 19 Aug 2014 20:52:25 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Vignesh Raman <Vignesh_Raman@mentor.com>
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiada_Wang@mentor.com
Subject: Re: [PATCH v2 0/2] dma: imx-sdma: Modify SDMA's remove operation
Message-ID: <20140819152225.GP13288@intel.com>
References: <1407244182-27302-1-git-send-email-Vignesh_Raman@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407244182-27302-1-git-send-email-Vignesh_Raman@mentor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 06:39:40PM +0530, Vignesh Raman wrote:
> This is a patch set which contains two patches which modify's sdma_remove 
> operation and add tasklet_kill in sdma_remove function.
Applied, thanks

-- 
~Vinod

