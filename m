Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaK2Rcq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 12:32:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbaK2Rcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:32:45 -0500
Date: Sat, 29 Nov 2014 19:32:26 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org,
        pbonzini@redhat.com, thuth@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 01/46] virtio: add low-level APIs for feature bits
Message-ID: <20141129173226.GG22746@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
 <1417118789-18231-2-git-send-email-mst@redhat.com>
 <20141128131057.6046a382@thinkpad-w530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128131057.6046a382@thinkpad-w530>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 01:10:57PM +0100, David Hildenbrand wrote:
> > Add low level APIs to test/set/clear feature bits.
> > For use by transports, to make it easier to
> > write code independent of feature bit array format.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/linux/virtio_config.h | 53 ++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 50 insertions(+), 3 deletions(-)
> > 
> 
> As these functions really set feature bits, I would rather name them:
> 
> virtio_has_feature ...
> virtio_set_feature ...
> virtio_clear_feature ...

We have these as high level APIs for drivers.
These are low level ones so need a different
name.


> But in general, this looks good to me!
