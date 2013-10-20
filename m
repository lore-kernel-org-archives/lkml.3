Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab3JTOOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 10:14:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:36126 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab3JTOOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 10:14:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,533,1378882800"; 
   d="scan'208";a="414048750"
Date: Sun, 20 Oct 2013 18:51:19 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: misc: remove deprecated IRQF_DISABLED
Message-ID: <20131020132119.GK14013@intel.com>
References: <1381641051-7287-1-git-send-email-michael.opdenacker@free-electrons.com>
 <20131013145400.GH2954@intel.com>
 <525B6623.8020102@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525B6623.8020102@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 05:33:55AM +0200, Michael Opdenacker wrote:
> Hi Vinod,
> 
> On 10/13/2013 04:54 PM, Vinod Koul wrote:
> > On Sun, Oct 13, 2013 at 07:10:51AM +0200, Michael Opdenacker wrote:
> >> This patch proposes to remove the use of the IRQF_DISABLED flag
> >>
> >> It's a NOOP since 2.6.35 and it will be removed one day.
> > Applied, thanks. Title shouldnt have misc as it doesnt convey anything.
> Thanks!
> 
> Indeed, I sent separate patches for files which had different
> maintainers, and grouped the patches for files which shared the same
> maintainer information.
> 
> I put "misc" to avoid suggesting that the patch is for everything under
> drivers/dma/, which is not the case. Wouldn't it have been confusing
> otherwise?
dmaengine: convert drivers to ....

would have been right too as you are taregtting a subsystem as a whole...

--
~Vinod
