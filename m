Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab3BTAc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:32:59 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61443 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab3BTAc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:32:58 -0500
Date: Tue, 19 Feb 2013 16:32:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [GIT PULL UPDATED] workqueue core changes for 3.9-rc1
Message-ID: <20130220003253.GA17414@htj.dyndns.org>
References: <20130219173937.GM17414@htj.dyndns.org>
 <20130219181356.GP17414@htj.dyndns.org>
 <20130220111125.8040fb7cd9c74c80baab6dde@canb.auug.org.au>
 <20130220111413.b9444b48400f808d8921be89@canb.auug.org.au>
 <20130220001925.GZ17414@htj.dyndns.org>
 <20130220112709.cc28b5b07afd6475157bb6ad@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220112709.cc28b5b07afd6475157bb6ad@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 11:27:09AM +1100, Stephen Rothwell wrote:
> >   $ git rev-list --pretty --oneline tmp ^next-20130219
> >   bd26f12 Merge branch 'for-3.9-async' into tmp
> >   0f985c9 Merge branch 'for-3.9-cleanups' into tmp
> >   1438ade5 workqueue: un-GPL function delayed_work_timer_fn()
> > 
> > tmp is for-3.9 + for-3.9-async + for-3.9-cleanups, so yeah other than
> > the last cherry-pick, everything seems to be in order.
> 
> Thanks for checking - sorry for the noise.

And the other direction too just in case.

 $ git rev-list --pretty --oneline for-next ^for-3.9 ^for-3.9-cleanups ^for-3.9-async
 a4791ca Merge branch 'for-3.9' into for-next
 3b8d914 Merge branch 'for-3.9-cleanups' into for-next
 de16266 Merge branch 'for-3.9' into for-next
 3437170 Merge branch 'for-3.9' into for-next
 26c3d00 Merge branch 'for-3.9-cleanups' into for-next
 93883c9 Merge branch 'for-3.9-async' into for-next

So, yeah, they all match up.

Thanks for keeping an eye on it. :)

-- 
tejun
