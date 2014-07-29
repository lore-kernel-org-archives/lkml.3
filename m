Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaG2OQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:16:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbaG2OQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:16:03 -0400
Date: Tue, 29 Jul 2014 16:15:45 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tomas Henzl <thenzl@redhat.com>, linux-kernel@vger.kernel.org,
        xjtuwjp@gmail.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: Re: [PATCH v2 RESEND 17/23] pm8001: Fix invalid return when
 request_irq() failed
Message-ID: <20140729141544.GA18029@dhcp-26-207.brq.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <5ecd9b80f705545c3dc85b2a4ae63a8ac3df8105.1405533479.git.agordeev@redhat.com>
 <53D79DE2.9000702@redhat.com>
 <20140729132020.GA7714@infradead.org>
 <53D7A62D.2090709@redhat.com>
 <20140729135641.GA14378@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729135641.GA14378@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 06:56:41AM -0700, Christoph Hellwig wrote:
> On Tue, Jul 29, 2014 at 03:48:29PM +0200, Tomas Henzl wrote:
> > I'm a bit confused - you were not commenting my text above I think?
> > 
> > I see in drivers-for-3.17 this patch already applied 5607de7
> > but not yet the next one (18/23) which also has a review, is there another ack needed?
> 
> Looks like I got a bit confused due to a non-applying patch, but it
> seems like the one that failed was the second one.  I'll look at it time
> permitting, but if someone familar with pm8001 can fix the reject for me
> that would help me greatly!

Hmm.. 18/23 applies with a minor fuzz against
git://git.infradead.org/users/hch/scsi-queue.git drivers-for-3.17

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
