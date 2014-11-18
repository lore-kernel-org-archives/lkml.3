Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaKRHut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 02:50:49 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:35380 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaKRHur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 02:50:47 -0500
Date: Tue, 18 Nov 2014 02:50:43 -0500
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH cgroup/for-3.19 3/3] cgroup: fix the async css offline
 wait logic in cgroup_subtree_control_write()
Message-ID: <20141118075043.GA7809@htj.dyndns.org>
References: <20141113215813.GA2598@htj.dyndns.org>
 <20141113215848.GB2598@htj.dyndns.org>
 <20141113215921.GC2598@htj.dyndns.org>
 <546AE794.5070902@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546AE794.5070902@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 02:30:44PM +0800, Zefan Li wrote:
> For all 3 patches:
> 
> Acked-by: Zefan Li <lizefan@huawei.com>

Applied 1-3 to cgroup/for-3.19.

Thanks.

-- 
tejun
