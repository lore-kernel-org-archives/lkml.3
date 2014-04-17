Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaDQOWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:22:17 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:51810 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaDQOWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:22:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140417141904.GH15326@htj.dyndns.org>
References: <1397744056-31119-1-git-send-email-nasa4836@gmail.com> <20140417141904.GH15326@htj.dyndns.org>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Thu, 17 Apr 2014 22:21:27 +0800
Message-ID: <CAHz2CGUESujf3np6a6-hOwqmA5p37F8YCV3XKtZ_7K+8tuU=2w@mail.gmail.com>
Subject: Re: [PATCH] cgroup: clean up obsolete code and comment
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 10:19 PM, Tejun Heo <tj@kernel.org> wrote:
> And cgroup_subsys[] doesn't require cgroup_mutex protection anymore.
> That comment and BUG_ON(!mutex_is_locked()) can be removed.  Can you
> please separate these out into a separate patch?
>
>> 2. cgroup_pidlist_seq_operations has no more user, remove it.
>> 3. s/pr_warning/pr_warn/g, suggested by scripts/checkpatch.pl.
>
> And let's put 2 and 3 in separate patches too.
>
>> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
>
> Also, please regenerate the patches on top of the following branch.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-populated-v2

Ok. This patch is based on review-populated-v2 already.


Thanks,
Jianyu Zhan
