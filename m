Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaBKQzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:55:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaBKQzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:55:13 -0500
Date: Tue, 11 Feb 2014 08:56:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH driver-core-next] kernfs: fix hash calculation in
 kernfs_rename_ns()
Message-ID: <20140211165628.GA29405@kroah.com>
References: <20140210225709.GH25350@mtj.dyndns.org>
 <20140211000141.GA30793@kroah.com>
 <20140211003956.GN25350@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211003956.GN25350@mtj.dyndns.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 07:39:56PM -0500, Tejun Heo wrote:
> Hello, Greg.
> 
> On Mon, Feb 10, 2014 at 04:01:41PM -0800, Greg Kroah-Hartman wrote:
> > Also, can you look into the merge of 3.14-rc2 into the driver-core-next
> > branch?  There are some conflicts in the kernfs code due to the lockdep
> > changes that I couldn't easily verify I got right, so I didn't do the
> > merge.  Could you give me a diff of the merge for me to work off of?
> 
> Sure thing.  It can be resolved by simply ignoring the
> driver-core-linus side.  kernfs_drain() updates in driver-core-next
> already has all the necessary lockdep flag checks through
> kernfs_lockdep().
> 
> The following git branch contains a test merge between
> driver-core-next and rc2.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git driver-core-next-test-merge-rc2

Thanks, I took this merge and pulled it into my tree.

greg k-h
