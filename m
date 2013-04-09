Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab3DINyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:54:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55219 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763998Ab3DINyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:54:38 -0400
Date: Tue, 9 Apr 2013 14:54:06 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Tony Lindgren <tony@atomide.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [RFC v2] dmaengine: omap-dma: Start DMA without delay for
	cyclic channels
Message-ID: <20130409135406.GA14500@n2100.arm.linux.org.uk>
References: <1364987862-14597-1-git-send-email-peter.ujfalusi@ti.com> <51626D88.8020809@ti.com> <20130408170956.GX30923@n2100.arm.linux.org.uk> <5163C118.5000207@ti.com> <5163C184.1010200@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5163C184.1010200@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 09:21:40AM +0200, Peter Ujfalusi wrote:
> Russell,
> 
> On 04/09/2013 09:19 AM, Peter Ujfalusi wrote:
> > On 04/08/2013 07:09 PM, Russell King - ARM Linux wrote:
> >> Now that I'm back from a short 4 day break, then yes, and the answer is
> >> that it's fine.  Who's handling the patch?
> > 
> > Thank you,
> > Péter
> 
> Can I add you acked-by to the patch?

You may, using the rmk+kernel address, not this one.  Thanks.
