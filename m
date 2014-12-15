Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaLOGil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 01:38:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:22440 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaLOGih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 01:38:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="498753643"
Date: Mon, 15 Dec 2014 12:08:35 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        =?iso-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>,
        Magnus Damm <damm+renesas@opensource.se>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH] dmaengine: rcar-dmac: Handle hardware descriptor
 allocation failure
Message-ID: <20141215063834.GM16827@intel.com>
References: <1416924617-15939-1-git-send-email-j@bitron.ch>
 <2735456.CKbC358ZrM@avalon>
 <87r3w79ea0.wl%kuninori.morimoto.gx@renesas.com>
 <2800395.CA9KFGZM72@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2800395.CA9KFGZM72@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 09:41:11PM +0200, Laurent Pinchart wrote:
> (Resend, as the message doesn't seem to have made it to the mailing lists)
> 
> On Thursday 11 December 2014 01:16:31 Kuninori Morimoto wrote:
> > > > On Mon, Dec 08, 2014 at 11:20:44PM +0530, Vinod Koul wrote:
> > > > > On Mon, Dec 08, 2014 at 07:40:15PM +0200, Laurent Pinchart wrote:
> > > > >>>> [GIT PULL FOR v3.19] R-Car DMA engine driver
> > > > >>>> http://www.spinics.net/lists/linux-sh/msg37764.html
> > > > >>> 
> > > > >>> And I dont seem to have this request in my Inbox :(
> > > > >>> Yes I do see it in archieves, so not sure how this is not present,
> > > > >>> not sure if the servers mangeled it!!
> > > > >> 
> > > > >> I haven't CC'ed you, I'll make sure to do so next time. The mail
> > > > >> should still have reached you through the mailing list though (I
> > > > >> assume you're subscribed to dmaengine@vger.kernel.org ;-)).
> > > > > 
> > > > > Yes I am, so should have reached me even though i wasnt cced
> > > > > I do see email reaching me from list without me being in CC, but then
> > > > > it wont hit my inbox and go to ML folder :)
> > > > > So generally its a good practice to CC relvant folks, lots of folks do
> > > > > ask that if ML is high volume
> > > > 
> > > > Hey Laurent,
> > > > 
> > > > I see that the oddity in commitlogs with change since artifacts after
> > > > SOB, can you please fix that up
> > > 
> > > My bad. I've fixed the problem and pushed the result to the same branch
> > > 
> > > 	git://linuxtv.org/pinchartl/fbdev.git dma/next
> > > 
> > > The only difference lies in the commit logs.
> > 
> > If my understanding was correct, we need to be based on Vinod's
> > topic/slave_caps_device_control_fix
> 
> Vinod, could you please comment on that ? To which kernel version do you plan 
> to push this series ? Do I need to rebase it ?
Hi Laurent,

I did a quick at the series, looks fine mostly. I have already sent by pull
request to linus earlier last week and its merged, so we need to merge it
for next one. So yes we need to fix and test this for caps and control API
fix. Can you do that and I will pull and put in my next for 3.20

One more thing I saw in driver "dmaengine: rcar-dmac: Add Renesas R-Car Gen2
DMA Controller (DMAC) driver" is the CONFIG_ARCH_DMA_ADDR_T_64BIT code. Can
you please explain a bit more on it, why do you need to modify addresses
based on config option?

-- 
~Vinod
