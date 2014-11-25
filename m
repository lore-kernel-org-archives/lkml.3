Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaKYVoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:44:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbaKYVoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:44:04 -0500
Date: Tue, 25 Nov 2014 23:43:42 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Thomas Huth <thuth@linux.vnet.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v4 13/42] virtio_blk: v1.0 support
Message-ID: <20141125214342.GE22343@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
 <1416933600-21398-14-git-send-email-mst@redhat.com>
 <20141125185516.7570c6e7.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125185516.7570c6e7.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 06:55:16PM +0100, Cornelia Huck wrote:
> On Tue, 25 Nov 2014 18:42:18 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > Based on patch by Cornelia Huck.
> > 
> > Note: for consistency, and to avoid sparse errors,
> >       convert all fields, even those no longer in use
> >       for virtio v1.0.
> > 
> > Reviewed-by: Thomas Huth <thuth@linux.vnet.ibm.com>
> > Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
> > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/uapi/linux/virtio_blk.h | 15 ++++-----
> >  drivers/block/virtio_blk.c      | 70 ++++++++++++++++++++++++-----------------
> >  2 files changed, 49 insertions(+), 36 deletions(-)
> > 
> 
> Is this sufficiently unchanged so that the original r-bs still hold?

You are right, I'm afraid I'll have to drop these.
Thomas, David, care to comment?
Even better - have the cycles to review the latest version?

-- 
MST
