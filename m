Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaBJTyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:54:15 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:60545 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbaBJTyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:54:07 -0500
Date: Mon, 10 Feb 2014 12:54:02 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.14
Message-ID: <20140210195402.GA3924@kernel.dk>
References: <20140210184412.GA18198@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210184412.GA18198@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10 2014, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> Please git pull the following branch:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-jens-3.14
> 
> which is based off v3.13-rc6. If you would like me to rebase it on
> a different branch/tag I would be more than happy to do so.

Older is fine, it's only an issue if you are ahead of the branch you
want to go into.

dd> 
> The patches are all bug-fixes and hopefully can go in 3.14.
> 
> They deal with xen-blkback shutdown and cause memory leaks
> as well as shutdown races. They should go to stable tree and if you
> are OK with I will ask them to backport those fixes.
> 
> There is also a fix to xen-blkfront to deal with unexpected state
> transition. And lastly a fix to the header where it was using the
> __aligned__ unnecessarily.

Pulled!

-- 
Jens Axboe

