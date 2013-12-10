Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab3LJLPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:15:12 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44186 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3LJLPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:15:08 -0500
Date: Tue, 10 Dec 2013 11:14:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dma: mv_xor: remove mv_desc_get_dest_addr()
Message-ID: <20131210111449.GY4360@n2100.arm.linux.org.uk>
References: <1385408365-8072-1-git-send-email-jason@lakedaemon.net> <20131128055706.GM8834@intel.com> <20131209235035.GA11632@n2100.arm.linux.org.uk> <20131210101331.GG29580@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210101331.GG29580@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 03:43:31PM +0530, Vinod Koul wrote:
> On Mon, Dec 09, 2013 at 11:50:35PM +0000, Russell King - ARM Linux wrote:
> > On Thu, Nov 28, 2013 at 11:27:06AM +0530, Vinod Koul wrote:
> > > + Dan
> > > 
> > > On Mon, Nov 25, 2013 at 07:39:25PM +0000, Jason Cooper wrote:
> > > > The following commit:
> > > > 
> > > >   54f8d501e842 dmaengine: remove DMA unmap from drivers
> > > > 
> > > > removed the last caller to mv_desc_get_dest_addr(), creating the
> > > > warning:
> > > > 
> > > >   drivers/dma/mv_xor.c:57:12: warning: 'mv_desc_get_dest_addr' defined
> > > >   but not used [-Wunused-function]
> > > > 
> > > > Remove it.
> > > > 
> > > > Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> > > Acked-by: Vinod Koul <vinod.koul@intel.com>
> > > 
> > > This should go thru Dan's tree
> > 
> > So what's happening with this patch?  I don't see it in -rc yet.
> Dan has applied this to his next. So this should show us in next rc1

Wrong answer.  This is a compile regression introduced in the last merge
window, it should be going into an -rc kernel.
