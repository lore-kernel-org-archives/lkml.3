Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934682Ab3BTATc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:19:32 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:60966 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375Ab3BTATb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:19:31 -0500
Date: Tue, 19 Feb 2013 16:19:25 -0800
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [GIT PULL UPDATED] workqueue core changes for 3.9-rc1
Message-ID: <20130220001925.GZ17414@htj.dyndns.org>
References: <20130219173937.GM17414@htj.dyndns.org>
 <20130219181356.GP17414@htj.dyndns.org>
 <20130220111125.8040fb7cd9c74c80baab6dde@canb.auug.org.au>
 <20130220111413.b9444b48400f808d8921be89@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220111413.b9444b48400f808d8921be89@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 11:14:13AM +1100, Stephen Rothwell wrote:
> HI Tejun,
> 
> On Wed, 20 Feb 2013 11:11:25 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > This is very different from what has been in linux-next (it looks like
> > you have been cherry-picking fixes from other sources into your for-next
> > branch?):
> 
> Or maybe what is in linux-next is a mash up of several different things?

Ooh, wq/for-next was combination of wq/for-3.9, wq/for-3.9-cleanups
and wq/for-3.9-async.  I'm fairly sure all the commits are accounted
for.  Checking again just in case....

  $ git rev-list --pretty --oneline tmp ^next-20130219
  bd26f12 Merge branch 'for-3.9-async' into tmp
  0f985c9 Merge branch 'for-3.9-cleanups' into tmp
  1438ade5 workqueue: un-GPL function delayed_work_timer_fn()

tmp is for-3.9 + for-3.9-async + for-3.9-cleanups, so yeah other than
the last cherry-pick, everything seems to be in order.

Thanks.

-- 
tejun
