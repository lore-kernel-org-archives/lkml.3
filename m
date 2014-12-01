Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaLALrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:47:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbaLALrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:47:06 -0500
Date: Mon, 1 Dec 2014 13:46:45 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, rusty@au1.ibm.com,
        nab@linux-iscsi.org, pbonzini@redhat.com, thuth@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v7 16/46] virtio_blk: v1.0 support
Message-ID: <20141201114645.GA17505@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
 <1417359787-10138-17-git-send-email-mst@redhat.com>
 <20141201091641.3085e682@thinkpad-w530>
 <20141201092658.GC15607@redhat.com>
 <20141201123315.1b95d06f.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201123315.1b95d06f.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 12:33:15PM +0100, Cornelia Huck wrote:
> On Mon, 1 Dec 2014 11:26:58 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > For some places on data path, it might be worth it
> > to cache the correct value e.g. as part of device
> > structure. This replaces a branch with a memory load,
> > so the gain would have to be measured, best done
> > separately?
> 
> I think we'll want to do some measuring once the basic structure is
> in place anyway.

What's meant by in place here?

> We should make sure that e.g. s390 only takes minor
> hit due to all that swapping that is needed for standard-compliant
> devices. Caching the value might certainly help in some paths.

Well, this is queued in linux-next for 3.19, so
now's the time to do it :)
