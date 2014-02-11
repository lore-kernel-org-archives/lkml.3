Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaBKAkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:40:05 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:45817 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaBKAkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:40:02 -0500
Date: Mon, 10 Feb 2014 19:39:56 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH driver-core-next] kernfs: fix hash calculation in
 kernfs_rename_ns()
Message-ID: <20140211003956.GN25350@mtj.dyndns.org>
References: <20140210225709.GH25350@mtj.dyndns.org>
 <20140211000141.GA30793@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211000141.GA30793@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

On Mon, Feb 10, 2014 at 04:01:41PM -0800, Greg Kroah-Hartman wrote:
> Also, can you look into the merge of 3.14-rc2 into the driver-core-next
> branch?  There are some conflicts in the kernfs code due to the lockdep
> changes that I couldn't easily verify I got right, so I didn't do the
> merge.  Could you give me a diff of the merge for me to work off of?

Sure thing.  It can be resolved by simply ignoring the
driver-core-linus side.  kernfs_drain() updates in driver-core-next
already has all the necessary lockdep flag checks through
kernfs_lockdep().

The following git branch contains a test merge between
driver-core-next and rc2.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git driver-core-next-test-merge-rc2

Thanks!

-- 
tejun
