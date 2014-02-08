Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaBHPZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 10:25:56 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:48946 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaBHPZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 10:25:55 -0500
Date: Sat, 8 Feb 2014 10:25:51 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.14-fixes] cgroup: four misc fixes
Message-ID: <20140208152551.GC3263@htj.dyndns.org>
References: <1390923125-4369-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390923125-4369-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 10:32:01AM -0500, Tejun Heo wrote:
> Hello,
> 
> This patchset contains the following four fixes found during
> conversion to kernfs.  0001-0003 are marked with -stable.
> 
>  0001-cgroup-fix-error-return-value-in-cgroup_mount.patch
>  0002-cgroup-fix-error-return-from-cgroup_create.patch
>  0003-cgroup-fix-locking-in-cgroup_cfts_commit.patch
>  0004-cgroup-move-the-one-off-opts-sanity-check-in-cgroup_.patch

Applied 0001-0003 to cgroup/for-3.14-fixes.  Thanks!

-- 
tejun
