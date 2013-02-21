Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3BUKh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:37:56 -0500
Received: from smtp2.macqel.be ([194.78.208.39]:6351 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab3BUKhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:37:54 -0500
Date: Thu, 21 Feb 2013 11:37:50 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>,
        Stany MARCEL <smarcel@pactenovation.fr>, Dan Williams <djbw@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH resent] dma: add the freescale-provided MultiChannel
	DMA driver
Message-ID: <20130221103750.GA18289@frolo.macqel>
References: <1359999503-29215-1-git-send-email-phdm@macqel.be> <20130220063147.GD23302@intel.com> <20130221082947.GA8799@frolo.macqel> <20130221095233.GA8451@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130221095233.GA8451@intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Thu, Feb 21, 2013 at 03:22:33PM +0530, Vinod Koul wrote:
> On Thu, Feb 21, 2013 at 09:29:47AM +0100, Philippe De Muyter wrote:
> > > 2. If you are not using dmaengine APIs then drivers/dma/ is not a place for you.
> > 
> > What would be the place then for a multi-architecture dma driver.  Freescale often
> > reuses the same blocks for its m68k (coldfire), powerpc and arm (iMX) product
> > lines.  A dma driver with many similarities is already under the arch/powerpc
> > subtree.  I would like to avoid that, because it clearly hurts reusability.
> So the question is will there be any more users of the driver other than the
> ethernet one? If No then it should live with ethernet driver.
> 
> DMAengine framework should be used where you have a system dma controller used
> by different subsystems.

I am not aware of any other user now, and my unique motivation is to get
the ethernet driver into the kernel, for which this is a first step.

As it is clearly a dma driver, it seemed to me fit to place it under
drivers/dma, but I can understand that you disagree.

I only wanted, by placing this driver under drivers/dma, to make it more
visible, eventually getting some help to make it DMAengine enabled, and
to avoid the need to move the files when the DMAengine interface would
be added.  So it is a chicken and egg question here :).

Again, thanks for your answers.  Stany and I are trying since Aug 2012
to get those drivers (MCD dma and MCD_FEC ethernet) in the kernel.

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
