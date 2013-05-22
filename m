Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3EVOjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:39:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab3EVOjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:39:08 -0400
Date: Wed, 22 May 2013 16:39:24 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Message-ID: <20130522143923.GD19383@dhcp-26-207.brq.redhat.com>
References: <cover.1369155164.git.agordeev@redhat.com>
 <20130521235003.GE6985@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521235003.GE6985@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 08:50:03AM +0900, Tejun Heo wrote:
> Hmmmmmm..... I'd normally apply this patch but block layer is just
> growing multi-queue support and libata is likely to be converted to mq
> in foreseeable future, so I'm a bit hesitant to make irq handling more
> sophiscated right now.  Would you be interested in looking into
> converting libata to blk mq support?  I'm pretty sure it'd yield far
> better outcome if done properly.

I am not committing, but will look into it, sure.

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
