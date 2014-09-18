Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbaIRR1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:27:52 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:33349 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaIRR1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:27:50 -0400
Date: Thu, 18 Sep 2014 13:27:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpuset: simplify proc_cpuset_show()
Message-ID: <20140918172747.GD13573@mtj.dyndns.org>
References: <541A91C3.9000305@huawei.com>
 <541A91D8.8070407@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541A91D8.8070407@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 04:03:36PM +0800, Zefan Li wrote:
> Use the ONE macro instead of REG, and we can simplify proc_cpuset_show().
> 
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Applied 1-2 to cgroup/for-3.18.

Thanks.

-- 
tejun
