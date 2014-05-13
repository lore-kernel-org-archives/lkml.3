Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbaEMQMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:12:51 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:45160 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbaEMQMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:12:42 -0400
Date: Tue, 13 May 2014 12:12:39 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET v2 cgroup/for-3.16] cgroup: post unified hierarchy
 fixes and updates
Message-ID: <20140513161227.GI23710@htj.dyndns.org>
References: <1399663975-315-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399663975-315-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 03:32:48PM -0400, Tejun Heo wrote:
> Hello,
> 
> Changes from the last take[L] are,
> 
> * 0002, 0003 and 0007 added.
> 
> * Other patches are refreshed without content change.
> 
> This patchset contains the following seven patches.
> 
>  0001-cgroup-fix-offlining-child-waiting-in-cgroup_subtree.patch
>  0002-cgroup-cgroup_idr_lock-should-be-bh.patch
>  0003-cgroup-css_release-shouldn-t-clear-cgroup-subsys.patch
>  0004-cgroup-update-and-fix-parsing-of-cgroup.subtree_cont.patch
>  0005-cgroup-use-restart_syscall-for-retries-after-offline.patch
>  0006-cgroup-use-release_agent_path_lock-in-cgroup_release.patch
>  0007-cgroup-rename-css_tryget-to-css_tryget_online.patch

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
