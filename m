Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab3DZTAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 15:00:34 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:47341 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3DZTAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:00:33 -0400
Date: Fri, 26 Apr 2013 12:00:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: restore the call to eventfd->poll()
Message-ID: <20130426190028.GB1433@mtj.dyndns.org>
References: <5179EC7C.5060208@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5179EC7C.5060208@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 10:54:52AM +0800, Li Zefan wrote:
> I mistakenly removed the call to eventfd->poll() while I was actually
> intending to remove the return value...
> 
> Calling evenfd->poll() will hook cgroup_event_wake() to the poll
> waitqueue, which will be called to unregister eventfd when rmdir a
> cgroup or close eventfd.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.10.  It'd have been better if the patch
description pointed to the specific commit which caused the problem.

Thanks.

-- 
tejun
