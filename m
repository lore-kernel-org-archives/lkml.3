Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaLIVtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:49:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaLIVtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:49:21 -0500
Date: Tue, 9 Dec 2014 23:49:07 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, cornelia.huck@de.ibm.com
Subject: Re: [PATCH 0/2] virtio_ccw: minor enhancements
Message-ID: <20141209214907.GA13855@redhat.com>
References: <1418133187-12436-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418133187-12436-1-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty, I guess you are busy.

I'd like to send all these patch series combined to Linus.  To see what
I have queued, you can check the vhost-next branch in my tree.

Will wait until tomorrow to give you a chance to respond.


On Tue, Dec 09, 2014 at 03:53:32PM +0200, Michael S. Tsirkin wrote:
> Two enhancements for virtio_ccw, on top of latest 1.0 patchset
> 
> Cornelia Huck (1):
>   virtio_ccw: finalize_features error handling
> 
> Michael S. Tsirkin (1):
>   virtio_ccw: future-proof finalize_features
> 
>  drivers/s390/kvm/virtio_ccw.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> -- 
> MST
> 
