Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbaLHRu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:50:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:63450 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbaLHRu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:50:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,539,1413270000"; 
   d="scan'208";a="644346779"
Date: Mon, 8 Dec 2014 23:20:44 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?iso-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <damm+renesas@opensource.se>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH] dmaengine: rcar-dmac: Handle hardware descriptor
 allocation failure
Message-ID: <20141208175044.GT16827@intel.com>
References: <1416924617-15939-1-git-send-email-j@bitron.ch>
 <1418057426.5069.6.camel@bitron.ch>
 <20141208171923.GS16827@intel.com>
 <2395334.C7dbfKWGeP@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2395334.C7dbfKWGeP@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 07:40:15PM +0200, Laurent Pinchart wrote:
> Hi Vinod,
> 
> On Monday 08 December 2014 22:49:24 Vinod Koul wrote:
> > On Mon, Dec 08, 2014 at 05:50:26PM +0100, Jürg Billeter wrote:
> > > Hi Vinod,
> > > 
> > > On Mon, 2014-12-08 at 17:06 +0530, Vinod Koul wrote:
> > > > Can you please rebase this on my next, this fails to apply for me
> > > 
> > > This is a patch for Laurent's new rcar-dmac driver, which doesn't appear
> > > to be in your next yet. Laurent has already merged my patch into his
> > > dma/next branch and included it in his pull request from November 27.
> > > 
> > > [GIT PULL FOR v3.19] R-Car DMA engine driver
> > > http://www.spinics.net/lists/linux-sh/msg37764.html
> > 
> > And I dont seem to have this request in my Inbox :(
> > Yes I do see it in archieves, so not sure how this is not present, not sure
> > if the servers mangeled it!!
> 
> I haven't CC'ed you, I'll make sure to do so next time. The mail should still 
> have reached you through the mailing list though (I assume you're subscribed 
> to dmaengine@vger.kernel.org ;-)).
Yes I am, so should have reached me even though i wasnt cced
I do see email reaching me from list without me being in CC, but then it
wont hit my inbox and go to ML folder :)
So generally its a good practice to CC relvant folks, lots of folks do ask
that if ML is high volume

Hopefully the Intel servers are playing nice with vger, that is my bigger
worry here.

-- 
~Vinod

