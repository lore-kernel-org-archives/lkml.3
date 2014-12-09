Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbaLIJMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:12:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:21921 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910AbaLIJM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:12:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,543,1413270000"; 
   d="scan'208";a="644719678"
Date: Tue, 9 Dec 2014 14:42:48 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jingchang Lu <jingchang.lu@freescale.com>
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] dmaengine: fsl-edma: fixup reg offset and hw S/G
 support in big-endian model
Message-ID: <20141209091248.GA16827@intel.com>
References: <1413968035-12855-1-git-send-email-jingchang.lu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413968035-12855-1-git-send-email-jingchang.lu@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 04:53:55PM +0800, Jingchang Lu wrote:
> The offset of all 8-/16-bit registers in big-endian eDMA model are
> swapped in a 32-bit size opposite those in the little-endian model.
> 
> The hardware Scatter/Gather requires the subsequent TCDs stored in memory
> in little endian independent of the register endian model, the eDMA engine
> will do the swap if need.
> 
> This patch also use regular assignment for tcd variables r/w
> instead of with io function previously that may not always be true.
Applied, thanks

-- 
~Vinod

