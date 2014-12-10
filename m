Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaLJIls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:41:48 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:56589 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaLJIlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:41:46 -0500
Date: Wed, 10 Dec 2014 09:41:39 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, dahi@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, Christian Borntraeger <borntraeger@de.ibm.com>,
        linux390@de.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 4/6] virtio_ccw: rev 1 devices set VIRTIO_F_VERSION_1
Message-ID: <20141210094139.7f2e2d01.cornelia.huck@de.ibm.com>
In-Reply-To: <20141209194052.GA21095@redhat.com>
References: <1418042769-25539-1-git-send-email-mst@redhat.com>
	<1418042769-25539-5-git-send-email-mst@redhat.com>
	<20141209120123.117ccfac.cornelia.huck@de.ibm.com>
	<20141209122118.GF3993@redhat.com>
	<20141209182319.20ce2dec.cornelia.huck@de.ibm.com>
	<20141209194052.GA21095@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121008-0005-0000-0000-000002669B4F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2014 21:40:52 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Tue, Dec 09, 2014 at 06:23:19PM +0100, Cornelia Huck wrote:
> > On Tue, 9 Dec 2014 14:21:18 +0200
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > On Tue, Dec 09, 2014 at 12:01:23PM +0100, Cornelia Huck wrote:
> > > > On Mon, 8 Dec 2014 15:06:03 +0200
> > > > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> > > > > diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
> > > > > index 789275f..f9f87ba 100644
> > > > > --- a/drivers/s390/kvm/virtio_ccw.c
> > > > > +++ b/drivers/s390/kvm/virtio_ccw.c
> > > > > @@ -758,6 +758,13 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
> > > > >  	struct virtio_feature_desc *features;
> > > > >  	struct ccw1 *ccw;
> > 
> > This needs
> > 
> > +	struct virtio_device *vdev = &vcdev->vdev;
> > 
> > to make it compile :)
> 
> In fact why does it?
> vdev is a parameter.

Never mind, messed up tree on my side.

