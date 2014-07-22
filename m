Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaGVI0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:26:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbaGVI0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:26:37 -0400
Date: Tue, 22 Jul 2014 10:27:16 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: bitmap tag: fix potential unwakeable sleep in
 bt_get()
Message-ID: <20140722082716.GA12370@dhcp-26-207.brq.redhat.com>
References: <1405930246-2051-1-git-send-email-agordeev@redhat.com>
 <53CCCC76.7060506@kernel.dk>
 <20140721083202.GA2107@dhcp-26-207.brq.redhat.com>
 <53CCD08C.80702@kernel.dk>
 <20140721091144.GB2107@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721091144.GB2107@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 11:11:44AM +0200, Alexander Gordeev wrote:
> > My bad, was looking at the wrong sources. What is the race? If the
> > clear and wakeup come in after the prepare_to_wait() but before the
> > io_schedule(), the io_schedule() will be a no-op and it wont
> > actually sleep. Your commit message doesn't mention any particular
> > details.
> 
> Let me examine the code.. It was few weeks ago and I can not
> remember what was that. And the changelog does not help :)

Jens,

I can not recall what was my concern. Sorry for the noise.

Thanks!

> > -- 
> > Jens Axboe
> > 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
