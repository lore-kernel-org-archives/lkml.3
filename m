Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3CMBTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 21:19:45 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:61890 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3CMBTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 21:19:43 -0400
Date: Tue, 12 Mar 2013 18:19:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] cgroup: consolidate cgroup_attach_task() and
 cgroup_attach_proc()
Message-ID: <20130313011939.GC2999@htj.dyndns.org>
References: <513FD395.7000906@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513FD395.7000906@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 09:17:09AM +0800, Li Zefan wrote:
> These two functions share most of the code.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
> 
> v2: Not necessary to move cgroup_attach_task_all().

I supposed this one is the one to apply?

-- 
tejun
