Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3EVRDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:03:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48014 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3EVRD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:03:28 -0400
Date: Wed, 22 May 2013 19:03:05 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Message-ID: <20130522170305.GD9563@kernel.dk>
References: <cover.1369155164.git.agordeev@redhat.com>
 <20130521235003.GE6985@mtj.dyndns.org>
 <20130522143923.GD19383@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522143923.GD19383@dhcp-26-207.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22 2013, Alexander Gordeev wrote:
> On Wed, May 22, 2013 at 08:50:03AM +0900, Tejun Heo wrote:
> > Hmmmmmm..... I'd normally apply this patch but block layer is just
> > growing multi-queue support and libata is likely to be converted to mq
> > in foreseeable future, so I'm a bit hesitant to make irq handling more
> > sophiscated right now.  Would you be interested in looking into
> > converting libata to blk mq support?  I'm pretty sure it'd yield far
> > better outcome if done properly.
> 
> I am not committing, but will look into it, sure.

Would be most awesome, I'm sure Nic would not mind a bit of help on the
SCSI/libata side :-)

And personally, can't wait to run it on the laptop! That's right, I
alpha test on the laptop.

-- 
Jens Axboe

