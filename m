Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3AXSUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:20:20 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:46667 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3AXSUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:20:18 -0500
Date: Thu, 24 Jan 2013 10:20:04 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cgroup: remove a NULL check in cgroup_exit()
Message-ID: <20130124182004.GL2373@mtj.dyndns.org>
References: <5100D810.5020406@huawei.com>
 <5100D827.20807@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5100D827.20807@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 02:43:51PM +0800, Li Zefan wrote:
> init_task.cgroups is initialized at boot phase, and whenver a ask
> is forked, it's cgroups pointer is inherited from its parent, and
> it's never set to NULL afterwards.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.9.

Thanks.

-- 
tejun
