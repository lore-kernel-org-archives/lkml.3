Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165Ab3DOG0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 02:26:54 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:44767 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab3DOG0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 02:26:52 -0400
Date: Sun, 14 Apr 2013 23:26:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: remove cgrp->top_cgroup
Message-ID: <20130415062640.GQ3050@htj.dyndns.org>
References: <516B9D41.8080508@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516B9D41.8080508@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 02:25:05PM +0800, Li Zefan wrote:
> It's not used, and it can be retrieved via cgrp->root->top_cgroup.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.10.  Thanks.

-- 
tejun
