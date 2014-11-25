Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113AbaKYVgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:36:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaKYVgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:36:35 -0500
Date: Tue, 25 Nov 2014 23:36:14 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 07/42] virtio_config: endian conversion for v1.0
Message-ID: <20141125213614.GB22343@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
 <1416933600-21398-8-git-send-email-mst@redhat.com>
 <20141125184557.1e171669.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125184557.1e171669.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 06:45:57PM +0100, Cornelia Huck wrote:
> On Tue, 25 Nov 2014 18:41:52 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > We (ab)use virtio conversion functions for device-specific
> > config space accesses.
> > 
> > Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> This looks odd with the various sign-offs but you as author...

Signoff tracks all contributors for developer's certificate
of origin purposes.

Looking at the patch itself, not a single line (except the subject) seems
to be shared with the original patch by Rusty that was posted with the
same subject, so I guess I could have dropped them here, but as I
refactor code I usually keep all signoffs around as a matter of policy.

Would you like yours to be dropped then?


> > ---
> >  include/linux/virtio_config.h | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
