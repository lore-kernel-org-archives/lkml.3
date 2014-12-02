Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716AbaLBSP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:15:57 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:65483 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbaLBSP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:15:56 -0500
Date: Tue, 2 Dec 2014 13:15:51 -0500
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH vfs 1/2] lib: implement ptrset
Message-ID: <20141202181551.GJ10918@htj.dyndns.org>
References: <20141113220927.GF2598@htj.dyndns.org>
 <20141125163707.GB3228@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125163707.GB3228@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

On Tue, Nov 25, 2014 at 05:37:07PM +0100, Jan Kara wrote:
> On Thu 13-11-14 17:09:27, Tejun Heo wrote:
> > Implement set of pointers.  Pointers can be added, deleted and
> > iterated.  It's currently implemented as a thin rbtree wrapper making
> > addition and removal O(log N).  A drawback is that iteration isn't RCU
> > safe, which is okay for now.  This will be used to remove
> > inode->i_devices.
>   Tejun, I've noticed this somewhat late but I guess you haven't noticed my
> patch series starting with a patch:
> blockdev: Don't use i_devices inode field
> 
> We can get rid of i_devices without tricks like this... I just need to
> improve how char devices are handled.

Ooh, that sounds perfect to me.  Please ignore these patches.

Thanks!

-- 
tejun
