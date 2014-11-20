Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbaKTNj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:39:58 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:35546 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbaKTNjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:39:55 -0500
Date: Thu, 20 Nov 2014 08:39:52 -0500
From: Tejun Heo <tj@kernel.org>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH vfs 2/2] {block|char}_dev: remove inode->i_devices
Message-ID: <20141120133952.GC14877@htj.dyndns.org>
References: <20141113220927.GF2598@htj.dyndns.org>
 <20141113221139.GG2598@htj.dyndns.org>
 <546DC5AD.3040606@plexistor.com>
 <20141120115052.GA32237@htj.dyndns.org>
 <546DE065.3090502@plexistor.com>
 <20141120131118.GB14877@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120131118.GB14877@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 08:11:18AM -0500, Tejun Heo wrote:
...
> creating another one-off behavior.  If we demote this to something
> which is shared only between block and char devs, we can go simpler
> and less versatile.  Where should it go tho?

So, one option is implementing something minimal in fs/devptrs.h or
somesuch and include it from block/char_dev.c.  If it isn't exposed as
a generic lib function, this can be a lot simpler.  I'll give it a
shot later today.

Thanks.

-- 
tejun
