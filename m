Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab3C2RbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:31:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48087 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab3C2RbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:31:24 -0400
Date: Fri, 29 Mar 2013 17:31:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Subject: Re: [RFC] dmaengine: omap-dma: Start DMA without delay
Message-ID: <20130329173100.GV30923@n2100.arm.linux.org.uk>
References: <1364566323-24144-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364566323-24144-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 03:12:03PM +0100, Peter Ujfalusi wrote:
> Remove the use of a tasklet to start the DMA channel when issue_pending is
> called.
> The use of tasklet delays the DMA start which can cause issues at drivers,
> for example the audio drivers expect that the DMA is started right away.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
> Hi Russell,
> 
> I know you are against removing the tasklet since you have planed to move the
> omap-dma to use runtime/dynamic DMA channel use.
> I have looked at the amba-pl08x.c driver which is doing that exactly (as you
> pointed out that to me). AMBA did not use tasklet either and I'm sure we can
> change the omap-dma driver to do the same in a same way as we could have done it
> with the tasklet use.

It's rather sad that you're ignoring what I'm saying, and going by what
another DMA engine driver - which is self contained - is doing, rather
than listening to my arguments against that approach.

I think in return I'll just ignore this patch, showing you the same
respect you show me.  Congratuations.
