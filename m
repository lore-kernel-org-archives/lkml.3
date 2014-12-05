Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaLERkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:40:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:53280 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbaLERkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:40:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,523,1413270000"; 
   d="scan'208";a="633369728"
Date: Fri, 5 Dec 2014 23:10:45 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] DMA: Fix allocation size for PL330 data buffer depth.
Message-ID: <20141205174045.GU3411@intel.com>
References: <1415294412-13818-1-git-send-email-Liviu.Dudau@arm.com>
 <20141112093952.GD24582@intel.com>
 <20141114123301.GK12037@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114123301.GK12037@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 12:33:01PM +0000, Liviu Dudau wrote:
> On Wed, Nov 12, 2014 at 09:39:52AM +0000, Vinod Koul wrote:
> > On Thu, Nov 06, 2014 at 05:20:12PM +0000, Liviu Dudau wrote:
> > > The datasheet for PL330 says that the data buffer value in the CRD
> > > register is 10bits wide. However, the value stored is "minus one",
> > > which the driver corrects for. Maximum value that the data buffer
> > > depth can have is 1024 lines, which requires 11 bits for storage.
> > > 
> > > While making updates I found printing the peripheral ID as a hex
> > > value to be more useful as the datasheet shows the values that way.
> > 
> > Applied, thanks
> 
> Thanks!
> 
> > 
> > Please snure you use the right subsytem name
> 
> Sorry about that. Just for clarity, it should've been 'dmaengine', right?
Yes...

-- 
~vinod

