Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbaLHRje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:39:34 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:39345 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaLHRjc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:39:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <damm+renesas@opensource.se>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH] dmaengine: rcar-dmac: Handle hardware descriptor allocation failure
Date: Mon, 08 Dec 2014 19:40:15 +0200
Message-ID: <2395334.C7dbfKWGeP@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20141208171923.GS16827@intel.com>
References: <1416924617-15939-1-git-send-email-j@bitron.ch> <1418057426.5069.6.camel@bitron.ch> <20141208171923.GS16827@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Monday 08 December 2014 22:49:24 Vinod Koul wrote:
> On Mon, Dec 08, 2014 at 05:50:26PM +0100, Jürg Billeter wrote:
> > Hi Vinod,
> > 
> > On Mon, 2014-12-08 at 17:06 +0530, Vinod Koul wrote:
> > > Can you please rebase this on my next, this fails to apply for me
> > 
> > This is a patch for Laurent's new rcar-dmac driver, which doesn't appear
> > to be in your next yet. Laurent has already merged my patch into his
> > dma/next branch and included it in his pull request from November 27.
> > 
> > [GIT PULL FOR v3.19] R-Car DMA engine driver
> > http://www.spinics.net/lists/linux-sh/msg37764.html
> 
> And I dont seem to have this request in my Inbox :(
> Yes I do see it in archieves, so not sure how this is not present, not sure
> if the servers mangeled it!!

I haven't CC'ed you, I'll make sure to do so next time. The mail should still 
have reached you through the mailing list though (I assume you're subscribed 
to dmaengine@vger.kernel.org ;-)).

> I will pull this tomorrow...

Thank you.

> > Please let me know if there is still a rebase required from my side.
> 
> Nope

-- 
Regards,

Laurent Pinchart

