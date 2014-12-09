Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaLISuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:50:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaLISup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:50:45 -0500
Date: Tue, 9 Dec 2014 20:50:35 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] virtio_ccw: minor enhancements
Message-ID: <20141209185035.GA19260@redhat.com>
References: <1418133187-12436-1-git-send-email-mst@redhat.com>
 <20141209182753.632da537.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209182753.632da537.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 06:27:53PM +0100, Cornelia Huck wrote:
> On Tue, 9 Dec 2014 15:53:32 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > Two enhancements for virtio_ccw, on top of latest 1.0 patchset
> > 
> > Cornelia Huck (1):
> >   virtio_ccw: finalize_features error handling
> > 
> > Michael S. Tsirkin (1):
> >   virtio_ccw: future-proof finalize_features
> > 
> >  drivers/s390/kvm/virtio_ccw.c | 18 +++++++++++-------
> >  1 file changed, 11 insertions(+), 7 deletions(-)
> > 
> 
> I tried to run this as a guest kernel with my virtio-1 qemu branch +
> your revision patch on top and it at least boots :) More testing
> tomorrow.

It's best if you pick my tree from git.
vhost-next branch.

