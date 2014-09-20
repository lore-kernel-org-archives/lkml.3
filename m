Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaITQYl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:24:41 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:57439 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaITQYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:24:39 -0400
Date: Sat, 20 Sep 2014 12:24:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] cgroup: fix missing unlock in cgroup_release_agent()
Message-ID: <20140920162436.GA3681@htj.dyndns.org>
References: <541D203F.4020902@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541D203F.4020902@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 02:35:43PM +0800, Zefan Li wrote:
> The patch 971ff4935538: "cgroup: use a per-cgroup work for release
> agent" from Sep 18, 2014, leads to the following static checker
> warning:
> 
> 	kernel/cgroup.c:5310 cgroup_release_agent()
> 	warn: 'mutex:&cgroup_mutex' is sometimes locked here and sometimes unlocked.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Applied to cgroup/for-3.18.

Thanks.

-- 
tejun
