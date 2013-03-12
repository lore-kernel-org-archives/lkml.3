Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794Ab3CLWir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:38:47 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40721 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab3CLWio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:38:44 -0400
Date: Tue, 12 Mar 2013 15:38:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 0/8] cgroup: a bunch of cleanups
Message-ID: <20130312223839.GM25266@htj.dyndns.org>
References: <513ED010.5060906@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513ED010.5060906@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 02:49:52PM +0800, Li Zefan wrote:
> Hi Tejun,
> 
> If you're busy with other stuff, just take your time to go through those
> patches.
> 
> 0001-cgroup-remove-cgroup_is_descentant.patch
> 0002-cgroup-remove-unused-variables-in-cgroup_destroy_loc.patch
> 0003-cgroup-hold-cgroup_mutex-before-calling-css_offline.patch
> 0004-cgroup-don-t-bother-to-resize-pid-array.patch
> 0005-cgroup-remove-useless-code-in-cgroup_write_event_con.patch
> 0006-cgroup-remove-unneeded-includes-from-cgroup.h.patch
> 0007-cgroup-fix-an-almost-harmless-off-by-one-bug.patch
> 0008-cgroup-consolidate-cgroup_attach_task-and-cgroup_att.patch

0001-0007 applied to cgroup/for-3.10.  0008 looks fine but in the diff
cgroup_attach_task_all() is removed completely and added back in
slightly different form.  If you wanna keep the functions ordered like
you posted, please put a separate patch to move
cgroup_attach_task_all() before the consolidation.

Thanks.

-- 
tejun
