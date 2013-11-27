Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab3K0X7C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:59:02 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39778 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836Ab3K0X66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:58:58 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/JRwcxlREAiOLcT+TxP+F3G1xvqScEy/g=
Date: Wed, 27 Nov 2013 18:58:51 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Olof Johansson <olof@lixom.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dma: mv_xor: remove mv_desc_get_dest_addr()
Message-ID: <20131127235851.GS2879@titan.lakedaemon.net>
References: <1385408365-8072-1-git-send-email-jason@lakedaemon.net>
 <20131125194631.GE2879@titan.lakedaemon.net>
 <CAOesGMhRYg4L72v8XCCSwSnLhYuZ6+aBTxPGNvVn=n=xpVm71A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMhRYg4L72v8XCCSwSnLhYuZ6+aBTxPGNvVn=n=xpVm71A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 11:45:24AM -0800, Olof Johansson wrote:
> On Mon, Nov 25, 2013 at 11:46 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> > On Mon, Nov 25, 2013 at 07:39:25PM +0000, Jason Cooper wrote:
> >> The following commit:
> >>
> >>   54f8d501e842 dmaengine: remove DMA unmap from drivers
> >>
> >> removed the last caller to mv_desc_get_dest_addr(), creating the
> >> warning:
> >>
> >>   drivers/dma/mv_xor.c:57:12: warning: 'mv_desc_get_dest_addr' defined
> >>   but not used [-Wunused-function]
> >>
> >> Remove it.
> >>
> >> Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> >> ---
> >>  drivers/dma/mv_xor.c | 6 ------
> >>  1 file changed, 6 deletions(-)
> >
> > Gah!  I sent too fast.  I meant to mention that I have this in my
> > mvebu/fixes branch, which gets merged into -next each night.  (The
> > warning was bugging me :) )
> >
> > Just let me know when you take it and I'll drop it from my branches.
> 
> Hmm. Please don't add patches for other subsystems into your -next
> tree, since then there is no indication for those of us who follow
> -next that the patch is not yet merged by the appropriate maintainer.

Ack.  Dropped.  Sorry for the confusion and thanks for setting me
straight.

thx,

Jason.
