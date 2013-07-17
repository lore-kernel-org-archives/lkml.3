Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab3GQE7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 00:59:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab3GQE7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 00:59:21 -0400
Date: Wed, 17 Jul 2013 08:00:32 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: rusty@rustcorp.com.au, netdev@vger.kernel.org, jasowang@redhat.com,
        amwang@redhat.com, akong@redhat.com, davej@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-net: put virtio net header inline with data
Message-ID: <20130717050032.GB10482@redhat.com>
References: <87vc4kcfzg.fsf@rustcorp.com.au>
 <20130709.213807.350021632586146971.davem@davemloft.net>
 <8761wc38ea.fsf@rustcorp.com.au>
 <20130716.123326.798365002638711260.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716.123326.798365002638711260.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 12:33:26PM -0700, David Miller wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Mon, 15 Jul 2013 11:13:25 +0930
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > 
> > For small packets we can simplify xmit processing
> > by linearizing buffers with the header:
> > most packets seem to have enough head room
> > we can use for this purpose.
> > Since existing hypervisors require that header
> > is the first s/g element, we need a feature bit
> > for this.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> I really think this has to wait until the next merge window, sorry.
> 
> Please resubmit this when I open net-next back up, thanks.

I assumed since -rc1 is out net-next is already open?
