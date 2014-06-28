Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaF1MNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 08:13:19 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:42525 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaF1MNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 08:13:17 -0400
Date: Sat, 28 Jun 2014 08:13:14 -0400
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, kmo@daterainc.com, nab@linux-iscsi.org
Subject: Re: [PATCHSET block/for-next] blk-mq: update freezing
Message-ID: <20140628121314.GD10829@htj.dyndns.org>
References: <1403104872-22236-1-git-send-email-tj@kernel.org>
 <53A1BC0E.8040704@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A1BC0E.8040704@kernel.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 09:19:26AM -0700, Jens Axboe wrote:
> >  percpu/for-3.17 6fbc07bbe2b5 ("percpu: invoke __verify_pcpu_ptr() from the generic part of accessors and operations")
> >+[1] [PATCHSET percpu/for-3.17] percpu: implement percpu_ref_reinit()
> >
> >and available in the following git branch.
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-mq-percpu_ref
> >
> >  block/blk-core.c       |   13 ++++---
> >  block/blk-mq.c         |   90 ++++++++++++++++---------------------------------
> >  block/blk-mq.h         |    2 -
> >  block/blk-sysfs.c      |    2 -
> >  include/linux/blkdev.h |    4 +-
> >  5 files changed, 44 insertions(+), 67 deletions(-)
> 
> Thanks Tejun, this looks pretty good. I was worried the tryget_live() would
> be too expensive, but that looks not to be the case. I like the cleanups to
> using a general mechanism. I'll run this through some functional and
> performance testing.

FYI, the percpu_ref changes needed by this patchset are applied to
percpu/for-3.17 branch which is stable and can be pulled into the
block tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.17

Thanks.

-- 
tejun
