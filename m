Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab3BOJcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 04:32:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50210 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3BOJcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 04:32:12 -0500
Date: Fri, 15 Feb 2013 10:30:52 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.8
Message-ID: <20130215093052.GZ21269@kernel.dk>
References: <20130214232630.GA8440@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214232630.GA8440@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14 2013, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> Please git pull the following branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.8
> 
> which has fixes to the blkback that I hope you can push to Linus for 3.8.
> The one that is quite vicious is the "xen-blkfront: drop the use of
> llist_for_each_entry_safe". It is a fix to re-do an "free-ing" loop - otherwise
> we hit a GCC 4.1.1 bug (so RHEL5 based) that turns the loop in an unbound one.

Taking pulls this late better all be stable@ worty patches. Are they?

-- 
Jens Axboe

