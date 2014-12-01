Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaLALrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:47:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbaLALrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:47:45 -0500
Date: Mon, 1 Dec 2014 13:47:26 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v7 27/46] virtio_net: enable v1.0 support
Message-ID: <20141201114726.GB17505@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
 <1417359787-10138-28-git-send-email-mst@redhat.com>
 <20141201124008.3d8ca343.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201124008.3d8ca343.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 12:40:08PM +0100, Cornelia Huck wrote:
> On Sun, 30 Nov 2014 17:11:30 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > Now that we have completed 1.0 support, enable it in our driver.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/net/virtio_net.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index a0e64cf..c6a72d3 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -2003,6 +2003,7 @@ static unsigned int features[] = {
> >  	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ,
> >  	VIRTIO_NET_F_CTRL_MAC_ADDR,
> >  	VIRTIO_F_ANY_LAYOUT,
> > +	VIRTIO_F_VERSION_1,
> >  };
> > 
> >  static struct virtio_driver virtio_net_driver = {
> 
> Shouldn't you move this after the patch disabling mac address writing?

Probably a good idea.
