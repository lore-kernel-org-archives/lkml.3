Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaLEQrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:47:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:43437 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbaLEQrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:47:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,522,1413270000"; 
   d="scan'208";a="619290287"
Date: Fri, 5 Dec 2014 22:17:58 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        dmaengine@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikanth Thokala <sthokal@xilinx.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH RESEND] Documentation: devicetree: Fix Xilinx VDMA
 specification
Message-ID: <20141205164758.GR3411@intel.com>
References: <1415800277-6817-1-git-send-email-afaerber@suse.de>
 <6067bede14b9421fa87db96bdc66dc66@BN1AFFO11FD040.protection.gbl>
 <5463A0F4.6060300@suse.de>
 <bd47278216b64375b32cdc9ed66fe907@BN1BFFO11FD024.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd47278216b64375b32cdc9ed66fe907@BN1BFFO11FD024.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 10:26:03AM -0800, Sören Brinkmann wrote:
> On Wed, 2014-11-12 at 07:03PM +0100, Andreas Färber wrote:
> > Am 12.11.2014 um 16:57 schrieb Sören Brinkmann:
> > > On Wed, 2014-11-12 at 02:51PM +0100, Andreas Färber wrote:
> > >> The specification requires xlnx,data-width, but example and driver use
> > >> xlnx,datawidth. Change the specification to match the implementation.
> > > 
> > > Isn't this the wrong way around? The bindings are considered API, so
> > > shouldn't the driver be fixed to match the spec?
> > 
> > In theory, patch review should've never let the two differ... ;)
> > 
> > It's not my driver, so I fixed the perceived inconsistency the least
> > invasive way; Michal and Srikanth seemed to concur at the time.
> > 
> > https://patchwork.kernel.org/patch/4620261/
> > 
> > > Are there already dts files out there using either of these options?
> > 
> > In upstream, no. microblaze and virtex440 use a
> > xlnx,include-datawidth-matching-0 property as precedence for the
> > spelling, whereas there is an fsl,data-width and an unused msix-data-width.
> > 
> > Downstream, yes: Beyond my own patch derived from the Parallella tree,
> > there's some in the ADI tree. None in the Xilinx tree on quick check.
> > 
> > I haven't encountered any using the documented xlnx,data-width - but
> > this patch was authored pre 3.17, haven't ran a full Web search again.
> 
> grepping through linux-next shows some usage of xlnx,datawidth, but
> only the single hit in  Documentation for xlnx,data-width.
> Other than VDMA the other hit seems to be just some DT
> documentation which I can't find a driver for...
> Anyhow, this patch is probably the best way of fixing this.
the driver had issues so want applied, I havent seen repot though. 
Will apply this now

-- 
~Vinod

> 
> Reviewed-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> 
> 	Thanks,
> 	Sören

-- 
