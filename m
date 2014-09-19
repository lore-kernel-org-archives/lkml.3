Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbaISNRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:17:13 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:42180 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaISNRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:17:12 -0400
Date: Fri, 19 Sep 2014 09:17:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH] cgroup: remove redundant check in cgroup_ino()
Message-ID: <20140919131708.GA30493@mtj.dyndns.org>
References: <541BE96B.1090605@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541BE96B.1090605@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 04:29:31PM +0800, Zefan Li wrote:
> After we implemented default unified hierarchy, cgrp->kn can never
> be NULL.
> 
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Applied to cgroup/for-3.18.

Thanks.

-- 
tejun
