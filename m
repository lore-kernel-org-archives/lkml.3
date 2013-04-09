Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937010Ab3DIHzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:55:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:18032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab3DIHzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:55:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,437,1363158000"; 
   d="scan'208";a="316438492"
Date: Tue, 9 Apr 2013 12:56:00 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dan Williams <djbw@fb.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [RFC v2] dmaengine: omap-dma: Start DMA without delay for
 cyclic channels
Message-ID: <20130409072600.GA31193@intel.com>
References: <1364987862-14597-1-git-send-email-peter.ujfalusi@ti.com>
 <51626D88.8020809@ti.com>
 <20130408170956.GX30923@n2100.arm.linux.org.uk>
 <20130408171519.GP10155@atomide.com>
 <5163BAA8.7040502@ti.com>
 <5163C103.8020101@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5163C103.8020101@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 09:19:31AM +0200, Peter Ujfalusi wrote:
> On 04/09/2013 08:52 AM, Santosh Shilimkar wrote:
> >> I suggest Peter resend the patch with also Grant + Linus W cc:d so
> >> they can queue it unless there are other related patches pending
> >> somewhere else.
> >>
> > Am curious on your suggestion. DMA engine patches are going via Vinod
> > Koul's tree so I think the $subject patch should follow the same
> > tree, No ?
> 
> AFAIK Vinod should be the correct person to pick it up, but I can CC Grant and
> Linus W as well.
Yes it should go thru dmaengine tree, sorry was travelling hence the delay, pls
resend the patch and I will do the needful
> 
> > Peter, if you plan to re-send, feel free to add my ack.
> 
> I'll figure out which stable release should have this applied and will resend.
> 
> -- 
> Péter
