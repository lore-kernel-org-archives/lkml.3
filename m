Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3DSS1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:27:15 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:42349 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3DSS1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:27:14 -0400
Date: Fri, 19 Apr 2013 11:27:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 04/10] cpuset: remove cpuset_test_cpumask()
Message-ID: <20130419182710.GB13811@mtj.dyndns.org>
References: <517137A7.4020605@huawei.com>
 <517137E7.20505@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517137E7.20505@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 08:26:15PM +0800, Li Zefan wrote:
> The test is done in set_cpus_allowed_ptr(), so it's redundant.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

For 0001-0004,

 Acked-by: Tejun Heo <tj@kernel.org>

I'll apply these into for-3.11 once v3.10-rc1 drops.

Thanks.

-- 
tejun
