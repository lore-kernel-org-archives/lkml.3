Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaG3P1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:27:45 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:63905 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbaG3P1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:27:43 -0400
Date: Wed, 30 Jul 2014 11:27:39 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Mike Qiu <qiudayu@linux.vnet.ibm.com>, cgroups <cgroups@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: fix the WARN_ON() in update_nodemasks_hier()
Message-ID: <20140730152739.GA23734@htj.dyndns.org>
References: <53D899A1.3080003@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D899A1.3080003@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 03:07:13PM +0800, Li Zefan wrote:
> The WARN_ON() is used to check if we break the legal hierarchy, on
> which the effective mems should be equal to configured mems.
> 
> Reported-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
> Tested-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.17.

Thanks.

-- 
tejun
