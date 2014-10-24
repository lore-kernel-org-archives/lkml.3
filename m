Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbaJXNtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:49:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525AbaJXNtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:49:11 -0400
Date: Fri, 24 Oct 2014 16:52:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC v4 07/17] virtio_config: endian conversion for v1.0
Message-ID: <20141024135235.GB6024@redhat.com>
References: <1414081380-14623-1-git-send-email-mst@redhat.com>
 <1414081380-14623-8-git-send-email-mst@redhat.com>
 <20141024105327.11377ea5.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024105327.11377ea5.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 10:53:27AM +0200, Cornelia Huck wrote:
> On Thu, 23 Oct 2014 19:24:30 +0300
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > We (ab)use virtio conversion functions for device-specific
> > config space accesses.
> > 
> > Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/linux/virtio_config.h | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> Not objecting to the patch, but something seems to have gotten messed
> up wrt authorship? You only adapted it, right?

I'll change author to Rusty.
