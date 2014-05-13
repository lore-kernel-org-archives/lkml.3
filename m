Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaEMPTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:19:14 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:50667 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaEMPTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:19:10 -0400
Date: Tue, 13 May 2014 11:19:07 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] cgroup: use restart_syscall() for retries after
 offline waits in cgroup_subtree_control_write()
Message-ID: <20140513151907.GF23710@htj.dyndns.org>
References: <1399663975-315-1-git-send-email-tj@kernel.org>
 <1399663975-315-6-git-send-email-tj@kernel.org>
 <5371A6DB.2050908@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5371A6DB.2050908@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 01:00:11PM +0800, Li Zefan wrote:
> Hi Tejun,
> 
> On 2014/5/10 3:32, Tejun Heo wrote:
> > After waiting for a child to finish offline,
> > cgroup_subtree_control_write() jumps up to retry from after the input
> > parsing and active protection breaking.  This retry makes the
> > scheduled locking update more difficult.
> 
> Could you explain this sentence more specific? I don't understand what
> "scheduled locking update" means.

Updating it to "planned cgroup_tree_mutex removal".

Thanks.

-- 
tejun
