Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaJCF1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:27:50 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:37344 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753089AbaJCF1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:27:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak4uAMcyLlR5LDjwPGdsb2JhbABggw6BK4IyhQevKQEBAQaVaYVqBAICgQkXAQYBAQEBODmEBAEBBDocIxAIAxgJJQ8FJQMHGhOIPb5KGBiFfYoRB4RLAQSdPJlxKy+CSgEBAQ
Date: Fri, 3 Oct 2014 15:27:37 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Thanos Makatos <thanos.makatos@citrix.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        jlayton@poochiereds.net, bfields@fieldses.org, jack@suse.cz
Subject: Re: [PATCH RFC] introduce ioctl to completely invalidate page cache
Message-ID: <20141003052737.GL24490@dastard>
References: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com>
 <542DAEAC.8010203@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542DAEAC.8010203@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 01:59:40PM -0600, Jens Axboe wrote:
> On 10/02/2014 10:09 AM, Thanos Makatos wrote:
> > This patch introduces a new ioctl called BLKFLUSHBUFS2, which is pretty

What a horrible name. Whatever happened to naming ioctls interfaces
after their function? i.e. BLKFLUSHINVAL?

Cheers,

Dave?

-- 
Dave Chinner
david@fromorbit.com
