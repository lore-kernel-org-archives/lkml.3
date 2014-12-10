Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbaLJWMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 17:12:14 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49371 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaLJWMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 17:12:13 -0500
Date: Wed, 10 Dec 2014 17:12:09 -0500
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET -mm] bitmap, cpumask, nodemask: implement pr_cont
 functions and use di"
Message-ID: <20141210221209.GA30844@htj.dyndns.org>
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
 <20141210134944.0599597b96026cf2f1597e45@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210134944.0599597b96026cf2f1597e45@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 01:49:44PM -0800, Andrew Morton wrote:
> On Wed, 10 Dec 2014 10:52:42 -0500 Tejun Heo <tj@kernel.org> wrote:
> > The first two patches implement the pr_cont variants of the formatting
> > functions.  The rest convert the existing users to pr_cont and seq
> > functions subsystem-by-subsystem.  It'd be the easiest to route all
> > through -mm but the conversion patches can go through individual
> > subsystem trees afterwards if necessary.
> 
> But you're working on other code which will depend on this?  If so
> perhaps these should be held in your tree.

Yeah, that works too.  I was still targeting 3.19 window and some of
the conversion patches were conflicting, so thought it'd be easier
through -mm.

Given that the changes aren't that invasive, I think it'd be still a
good idea to merge the workqueue debugging during this merge window as
it gives a lot more visibility into tricky issues.  Once it's agreed
on, I'll try to route the feature patches (the first two from this
series + actual workqueue changes) early through wq branch.

Thanks.

-- 
tejun
