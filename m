Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934043Ab3DGQav (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 12:30:51 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:47515 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934026Ab3DGQat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 12:30:49 -0400
Date: Sun, 7 Apr 2013 09:30:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] cgroup: unexport locking interface
Message-ID: <20130407163045.GB12038@htj.dyndns.org>
References: <1365118589-10619-1-git-send-email-tj@kernel.org>
 <5161064D.30000@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5161064D.30000@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 07, 2013 at 01:38:21PM +0800, Li Zefan wrote:
> On 2013/4/5 7:36, Tejun Heo wrote:
> > Hello,
> > 
> > Most cgroup_mutex abuses outside cgroup core proper have been
> > eradicated but there's still one use remaining and locking interface
> > is still exported.  This patchset updates the last user and unexports
> > the locking interface and is composed of the following five patches.
> > 
> >  0001-cgroup-cpuset-replace-move_member_tasks_to_cpuset-wi.patch
> >  0002-cgroup-relocate-cgroup_lock_live_group-and-cgroup_at.patch
> >  0003-cgroup-unexport-locking-interface-and-cgroup_attach_.patch
> >  0004-cgroup-kill-cgroup_-un-lock.patch
> >  0005-cgroup-remove-cgroup_lock_is_held.patch
> > 
> 
> Acked-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
