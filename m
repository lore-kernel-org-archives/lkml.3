Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab3KNPYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:24:02 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57127 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3KNPXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:23:54 -0500
Date: Thu, 14 Nov 2013 08:23:50 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH-next] block/blk-mq: remove newly added instances of
 __cpuinit
Message-ID: <20131114152350.GA7533@kernel.dk>
References: <1383851058-11688-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383851058-11688-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07 2013, Paul Gortmaker wrote:
> commit 320ae51feed5c2f13664aa05a76bec198967e04d [Nov7 linux-next
> via "Merge remote-tracking branch 'block/for-next'"] adds
> "blk-mq: new multi-queue block IO queueing mechanism".  This
> commit added new instances of __cpuinit usage.
> 
> We removed this a couple versions ago; we now want to remove
> the compat no-op stubs.  Introducing new users is not what
> we want to see at this point in time, as it will break once
> the stubs are gone.

Thanks, added.

-- 
Jens Axboe

