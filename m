Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbaDQPiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:38:08 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36503 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaDQPiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:38:04 -0400
Date: Thu, 17 Apr 2014 11:38:00 -0400
From: Tejun Heo <tj@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cgroup: clean up obsolete comment for
 parse_cgroupfs_options()
Message-ID: <20140417153800.GO15326@htj.dyndns.org>
References: <1397748555-6647-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397748555-6647-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:29:15PM +0800, Jianyu Zhan wrote:
> Commit 1d5be6b287c8efc87(cgroup: move module ref handling into
> rebind_subsystems()) makes parse_cgroupfs_options() no longer
> takes refcounts on subsystems.
> 
> And unified hierachy makes parse_cgroupfs_options not need to
> call with cgroup_mutex held to protect the cgroup_subsys[].
> 
> So this patch cleanups these comment and BUG_ON().
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Rolled 1-3 to the pending patchset.  Will be applied after the unified
patchset.  I dropped the comment above parse_cgroupfs_options()
altogether as it didn't contain anything actually useful.  Also, next
time, please put the patches in a series into a thread so that they're
easier to track.

Thanks.

-- 
tejun
