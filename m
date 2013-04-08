Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934954Ab3DHRQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:16:17 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:42524 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934558Ab3DHRPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:15:38 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Ypc9v69ETDxtcAwJ7o3fL
Date: Mon, 8 Apr 2013 10:15:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [RFC v2] dmaengine: omap-dma: Start DMA without delay for
 cyclic channels
Message-ID: <20130408171519.GP10155@atomide.com>
References: <1364987862-14597-1-git-send-email-peter.ujfalusi@ti.com>
 <51626D88.8020809@ti.com>
 <20130408170956.GX30923@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408170956.GX30923@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [130408 10:15]:
> On Mon, Apr 08, 2013 at 09:11:04AM +0200, Peter Ujfalusi wrote:
> > Russell,
> > 
> > On 04/03/2013 01:17 PM, Peter Ujfalusi wrote:
> > > cyclic DMA is only used by audio which needs DMA to be started without a
> > > delay.
> > > If the DMA for audio is started using the tasklet we experience random
> > > channel switch (to be more precise: channel shift).
> > > 
> > > Reported-by: Peter Meerwald <pmeerw@pmeerw.net>
> > > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > > ---
> > > Hi Russell,
> > > 
> > > Instead of removing the tasklet we can identify the DMA channel used by audio
> > > based on the cyclic flag of the channel.
> > > I think this can be used as a short term solution to fix the audio channel shift
> > > issue and later when we have the dynamic DMA channel allocation we can adjust
> > > the code.
> > 
> > Could you, please look at this patch?
> 
> Now that I'm back from a short 4 day break, then yes, and the answer is
> that it's fine.  Who's handling the patch?

I suggest Peter resend the patch with also Grant + Linus W cc:d so
they can queue it unless there are other related patches pending
somewhere else.

Regards,

Tony
