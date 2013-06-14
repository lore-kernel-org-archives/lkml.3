Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060Ab3FNCmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:42:05 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44303 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759632Ab3FNCmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:42:00 -0400
Date: Thu, 13 Jun 2013 19:41:57 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        koverstreet@google.com, linux-kernel@vger.kernel.org,
        cl@linux-foundation.org
Subject: Re: [PATCHSET v2 cgroup/for-3.11] cgroup: convert
 cgroup_subsys_state refcnt to percpu_ref
Message-ID: <20130614024157.GB7846@htj.dyndns.org>
References: <1371096298-24402-1-git-send-email-tj@kernel.org>
 <51B960FF.7070604@huawei.com>
 <20130613175627.GC10799@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613175627.GC10799@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 10:56:27AM -0700, Tejun Heo wrote:
> On Thu, Jun 13, 2013 at 02:04:47PM +0800, Li Zefan wrote:
> > >  0001-cgroup-remove-now-unused-css_depth.patch
> > >  0002-cgroup-consistently-use-cset-for-struct-css_set-vari.patch
> > >  0003-cgroup-bring-some-sanity-to-naming-around-cg_cgroup_.patch
> > >  0004-cgroup-use-kzalloc-instead-of-kmalloc.patch
> > >  0005-cgroup-clean-up-css_-try-get-and-css_put.patch
> > >  0006-cgroup-rename-CGRP_REMOVED-to-CGRP_DEAD.patch
> > >  0007-cgroup-drop-unnecessary-RCU-dancing-from-__put_css_s.patch
> > >  0008-cgroup-remove-cgroup-count-and-use.patch
> > >  0009-cgroup-reorder-the-operations-in-cgroup_destroy_lock.patch
> > >  0010-cgroup-split-cgroup-destruction-into-two-steps.patch
> > >  0011-cgroup-use-percpu-refcnt-for-cgroup_subsys_states.patch
> > 
> > Acked-by: Li Zefan <lizefan@huawei.com>
> 
> Applied 0001-0008 to cgroup/for-3.11.  Will apply the reset once the
> percpu-refcount side is settled.

Applied 0009-0010 to cgroup/for-3.11; then pulled in percpu/for-3.11
for percpu_ref and applied 0011.

Thanks!

-- 
tejun
