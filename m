Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab3FIPsD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 11:48:03 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:61415 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab3FIPsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 11:48:01 -0400
Date: Sun, 9 Jun 2013 08:47:57 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH v3 2/7] cpuset: remove async hotplug propagation work
Message-ID: <20130609154757.GC2835@htj.dyndns.org>
References: <51B4475A.8030509@huawei.com>
 <51B44787.2030601@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B44787.2030601@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 05:14:47PM +0800, Li Zefan wrote:
> As we can drop rcu read lock while iterating cgroup hierarchy,
> we don't have to do propagation asynchronously via workqueue.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied 1-2 to cgroup/for-3.11-cpuset.  Thanks!

-- 
tejun
