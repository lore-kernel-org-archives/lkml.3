Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbbAVMtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:49:25 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:39779 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbbAVMtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:49:23 -0500
Date: Thu, 22 Jan 2015 07:49:20 -0500
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150122124920.GD25645@htj.dyndns.org>
References: <20150121171953.823177070@goodmis.org>
 <20150121230007.GA10389@kroah.com>
 <20150122042330.GU29656@ZenIV.linux.org.uk>
 <20150121233553.19d9ac5c@grimm.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121233553.19d9ac5c@grimm.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 11:35:53PM -0500, Steven Rostedt wrote:
> On Thu, 22 Jan 2015 04:23:30 +0000
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > I would recommend against that - kernfs is overburdened by their need
> > to accomodate cgroup weirdness.  IMO it's not a good model for
> > anything, other than an anti-hard-drugs poster ("don't shoot that
> > shit, or you might end up hallucinating _this_").
> 
> OK, I'm not the only one that thought kernfs seemed to go all over the
> place. I guess I now know why. It was more of a hook for cgroups. I can

Again, not true at all.

> understand why cgroups needed it, as I found that creating files from a
> mkdir and removing them with rmdir causes some pain in vfs with
> handling of locking. As that's what I'm working on overcoming now.
> 
> But I think I solved my issues (testing it now), and hopefully by
> tomorrow, I'll have a V2 out.

I'd strongly recomment just using kernfs.  If you find something wrong
with it, let's fix it, please.

Thanks.

-- 
tejun
