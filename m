Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab3EJH7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 03:59:47 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:33896 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3EJH7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 03:59:45 -0400
Date: Fri, 10 May 2013 09:59:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Libin <huawei.libin@huawei.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, jiang.liu@huawei.com, guohanjun@huawei.com,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 22/42] sched/debug: Fix sd->*_idx limit range avoiding overflow
Message-ID: <20130510075941.GB6364@gmail.com>
References: <20130423215205.523980967@linuxfoundation.org>
 <20130423215207.778285571@linuxfoundation.org>
 <1368152071.17344.5.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368152071.17344.5.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ben Hutchings <ben@decadent.org.uk> wrote:

> On Tue, 2013-04-23 at 14:52 -0700, Greg Kroah-Hartman wrote:
> > 3.8-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: libin <huawei.libin@huawei.com>
> > 
> > commit fd9b86d37a600488dbd80fe60cca46b822bff1cd upstream.
> > 
> > Commit 201c373e8e ("sched/debug: Limit sd->*_idx range on
> > sysctl") was an incomplete bug fix.
> [...]
> 
> It seems like both these commits ought to be applied to earlier stable
> branches.  Or was the lack of range checking a regression after 3.4?

Both should be applied indeed.

They are not a huge problem as all these facilities are for debugging and 
are root-only, but the two fixes should be applied together or not at all.

Thanks,

	Ingo
