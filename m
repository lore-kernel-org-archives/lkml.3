Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934772AbaLLTkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:40:23 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:44401 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581AbaLLTkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:40:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>,
        Magnus Damm <damm+renesas@opensource.se>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH] dmaengine: rcar-dmac: Handle hardware descriptor allocation failure
Date: Fri, 12 Dec 2014 21:41:11 +0200
Message-ID: <2800395.CA9KFGZM72@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <87r3w79ea0.wl%kuninori.morimoto.gx@renesas.com>
References: <1416924617-15939-1-git-send-email-j@bitron.ch> <2735456.CKbC358ZrM@avalon> <87r3w79ea0.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resend, as the message doesn't seem to have made it to the mailing lists)

On Thursday 11 December 2014 01:16:31 Kuninori Morimoto wrote:
> > > On Mon, Dec 08, 2014 at 11:20:44PM +0530, Vinod Koul wrote:
> > > > On Mon, Dec 08, 2014 at 07:40:15PM +0200, Laurent Pinchart wrote:
> > > >>>> [GIT PULL FOR v3.19] R-Car DMA engine driver
> > > >>>> http://www.spinics.net/lists/linux-sh/msg37764.html
> > > >>> 
> > > >>> And I dont seem to have this request in my Inbox :(
> > > >>> Yes I do see it in archieves, so not sure how this is not present,
> > > >>> not sure if the servers mangeled it!!
> > > >> 
> > > >> I haven't CC'ed you, I'll make sure to do so next time. The mail
> > > >> should still have reached you through the mailing list though (I
> > > >> assume you're subscribed to dmaengine@vger.kernel.org ;-)).
> > > > 
> > > > Yes I am, so should have reached me even though i wasnt cced
> > > > I do see email reaching me from list without me being in CC, but then
> > > > it wont hit my inbox and go to ML folder :)
> > > > So generally its a good practice to CC relvant folks, lots of folks do
> > > > ask that if ML is high volume
> > > 
> > > Hey Laurent,
> > > 
> > > I see that the oddity in commitlogs with change since artifacts after
> > > SOB, can you please fix that up
> > 
> > My bad. I've fixed the problem and pushed the result to the same branch
> > 
> > 	git://linuxtv.org/pinchartl/fbdev.git dma/next
> > 
> > The only difference lies in the commit logs.
> 
> If my understanding was correct, we need to be based on Vinod's
> topic/slave_caps_device_control_fix

Vinod, could you please comment on that ? To which kernel version do you plan 
to push this series ? Do I need to rebase it ?

-- 
Regards,

Laurent Pinchart
