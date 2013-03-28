Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3C1STR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:19:17 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:46213 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab3C1STP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:19:15 -0400
Date: Thu, 28 Mar 2013 11:19:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 5/5] cgroup: Remove subsys.active flag
Message-ID: <20130328181910.GE14088@htj.dyndns.org>
References: <5153EF24.3040608@huawei.com>
 <5153EF8D.2080502@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5153EF8D.2080502@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 03:21:49PM +0800, Li Zefan wrote:
> The only user was cpuacct.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

  Acked-by: Tejun Heo <tj@kernel.org>

Please feel free to route through -tip with the other cpuacct changes.

Thanks.

-- 
tejun
