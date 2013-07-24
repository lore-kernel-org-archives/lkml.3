Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab3GXTnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:43:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab3GXTn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:43:28 -0400
Date: Wed, 24 Jul 2013 22:44:42 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        jasowang@redhat.com, amwang@redhat.com, akong@redhat.com,
        davej@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-net: put virtio net header inline with data
Message-ID: <20130724194442.GA20441@redhat.com>
References: <8761wc38ea.fsf@rustcorp.com.au>
 <20130716.123326.798365002638711260.davem@davemloft.net>
 <20130717050032.GB10482@redhat.com>
 <20130716.220529.49723311269417873.davem@davemloft.net>
 <8761w9zptv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761w9zptv.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 03:32:36PM +0930, Rusty Russell wrote:
> David Miller <davem@davemloft.net> writes:
> > From: "Michael S. Tsirkin" <mst@redhat.com>
> > Date: Wed, 17 Jul 2013 08:00:32 +0300
> >
> >> On Tue, Jul 16, 2013 at 12:33:26PM -0700, David Miller wrote:
> >>> From: Rusty Russell <rusty@rustcorp.com.au>
> >>> Date: Mon, 15 Jul 2013 11:13:25 +0930
> >>> 
> >>> > From: Michael S. Tsirkin <mst@redhat.com>
> >>> > 
> >>> > For small packets we can simplify xmit processing
> >>> > by linearizing buffers with the header:
> >>> > most packets seem to have enough head room
> >>> > we can use for this purpose.
> >>> > Since existing hypervisors require that header
> >>> > is the first s/g element, we need a feature bit
> >>> > for this.
> >>> > 
> >>> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >>> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> >>> 
> >>> I really think this has to wait until the next merge window, sorry.
> >>> 
> >>> Please resubmit this when I open net-next back up, thanks.
> >> 
> >> I assumed since -rc1 is out net-next is already open?
> >
> > -rc1 being released never makes net-next open.  Instead, I explicitly
> > open it up at some point in time after -rc1 when I feel that things
> > have settled down enough.
> >
> > And when that happens, I announce so here.
> >
> > So you have to follow my announcements here on netdev to know
> > when net-next is actually open.
> 
> Thanks for letting me know.  I'm sure that works well for others, but I
> can't follow the mailing lists of every maintainer I deal with.
> 
> Fortunately, you're the paragon for acking applied patches, so if I hit
> this failure mode again I will know.
> 
> Cheers,
> Rusty.

In case you missed this, net-next opened Fri, 19 Jul 2013.

-- 
MST
