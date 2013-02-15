Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161739Ab3BONb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:31:27 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39097 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161179Ab3BONb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 08:31:26 -0500
Date: Fri, 15 Feb 2013 08:31:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.8
Message-ID: <20130215133121.GF11777@phenom.dumpdata.com>
References: <20130214232630.GA8440@phenom.dumpdata.com>
 <20130215093052.GZ21269@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130215093052.GZ21269@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 10:30:52AM +0100, Jens Axboe wrote:
> On Thu, Feb 14 2013, Konrad Rzeszutek Wilk wrote:
> > Hey Jens,
> > 
> > Please git pull the following branch:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.8
> > 
> > which has fixes to the blkback that I hope you can push to Linus for 3.8.
> > The one that is quite vicious is the "xen-blkfront: drop the use of
> > llist_for_each_entry_safe". It is a fix to re-do an "free-ing" loop - otherwise
> > we hit a GCC 4.1.1 bug (so RHEL5 based) that turns the loop in an unbound one.
> 
> Taking pulls this late better all be stable@ worty patches. Are they?

I think that is OK - considering I just sent you _another_ git pull.

If it is not too much trouble, could you take it in your 3.9 tree and once Linus
pulls them I will send an email to Greg asking them to backport the git commits?

Much appreciated and sorry for these very late patches.

> 
> -- 
> Jens Axboe
> 
