Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933764AbaFQRjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:39:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933231AbaFQRjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:39:14 -0400
Date: Tue, 17 Jun 2014 19:39:56 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 0/3] blk-mq: bitmap tag: Fix few races
Message-ID: <20140617173956.GB361@dhcp-26-207.brq.redhat.com>
References: <cover.1402582256.git.agordeev@redhat.com>
 <20140617103531.GA13924@infradead.org>
 <53A040CF.2000105@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A040CF.2000105@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 07:21:19AM -0600, Jens Axboe wrote:
> On 2014-06-17 04:35, Christoph Hellwig wrote:
> >Jens, did you plan to pick these up?  There's a few bits of low hanging
> >fruit for cleanups / micro-optimizations in this area, but I don't want
> >to create conflicts with Alexanders work.
> 
> I'm evaluating just getting rid of the cyclic waits, which is why
> I've held off. But the patches don't apply to the current tree
> anyway, so they would need a rediffing no matter what.

Hi Jens,

Patches 1/3 and 2/3 apply to Linus's tree and could go in without patch 3/3.
I'll post v2 of 3/3.

> -- 
> Jens Axboe
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
