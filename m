Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab3K1CNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:13:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38600 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab3K1CN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:13:28 -0500
Date: Wed, 27 Nov 2013 19:13:25 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.13-take-two (bug-fixes to
 xen-blkfront)
Message-ID: <20131128021325.GI2360@kernel.dk>
References: <20131126163157.GB2959@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126163157.GB2959@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26 2013, Konrad Rzeszutek Wilk wrote:
> 
> Hey Jens,
> 
> Please git pull the following branch:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-jens-3.13-take-two
> 
> which has bug-fixes. It is based on todays on your 'for-3.13/drivers'
> (f7cb20f03dc6dff1b19942cf3dda6d154c86f29b "floppy: Correct documentation of driver
> options when used as a module.").
> 
> Fixes are to fix a compiler warning and a issue discovered by Coverity.
> Please pull!
> 
> Thank you!
> 
> Felipe Pena (1):
>       block: xen-blkfront: Fix possible NULL ptr dereference
> 
> Tim Gardner (1):
>       xen-blkfront: Silence pfn maybe-uninitialized warning

Thanks, pulled.

-- 
Jens Axboe

