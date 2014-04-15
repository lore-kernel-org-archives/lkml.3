Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbaDOOy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:54:58 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:45434 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaDOOyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:54:55 -0400
Date: Tue, 15 Apr 2014 10:54:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, john@johnmccutchan.com, rlove@rlove.org,
        eparis@parisplace.org, gregkh@linuxfoundation.org,
        serge.hallyn@ubuntu.com, lennart@poettering.net, kay@vrfy.org
Subject: Re: [PATCH 3/3] cgroup: implement cgroup.subtree_populated for the
 default hierarchy
Message-ID: <20140415145450.GL1863@htj.dyndns.org>
References: <1397511846-2904-1-git-send-email-tj@kernel.org>
 <1397511846-2904-4-git-send-email-tj@kernel.org>
 <534C83F1.9020106@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534C83F1.9020106@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 15, 2014 at 08:57:21AM +0800, Li Zefan wrote:
> Is cgroup.tree_populated a better name?
> 
> cgroup.subtree_control controls child cgroups only, but .subtree_populated
> shows 1 if there're tasks in the cgroup or its children, so the two
> are a bit inconsistent to me.

Yes, good catch.  subtree_control affects subtree proper.
subtree_populated covers self too.  The difference is subtle and the
trade off between shared pattern in names and clarifying the subtlety
didn't seem clear-cut to me.  Hmmm....

-- 
tejun
