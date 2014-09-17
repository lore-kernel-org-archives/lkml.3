Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbaIQVgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:36:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47464 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbaIQVgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:36:07 -0400
Date: Thu, 18 Sep 2014 06:36:00 +0900
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] cgroup: remove bogus comments
Message-ID: <20140917213600.GC15795@mtj.dyndns.org>
References: <54195FE1.9030607@huawei.com>
 <5419602C.4080303@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5419602C.4080303@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 06:19:24PM +0800, Li Zefan wrote:
> We never grab cgroup mutex in fork and exit paths no matter whether
> notify_on_release is set or not.
> 
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Applied 1-3 to cgroup/for-3.18.

Thanks.

-- 
tejun
