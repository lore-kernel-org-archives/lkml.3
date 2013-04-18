Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936498Ab3DRSgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:36:06 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64646 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab3DRSgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:36:03 -0400
Date: Thu, 18 Apr 2013 11:36:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Rami Rosen <ramirose@gmail.com>
Cc: lizefan@huawei.com, aris@redhat.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        serge.hallyn@canonical.com
Subject: Re: [PATCH] devcg: remove parent_cgroup.
Message-ID: <20130418183600.GI9897@mtj.dyndns.org>
References: <1366143895-21535-1-git-send-email-ramirose@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366143895-21535-1-git-send-email-ramirose@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 11:24:55PM +0300, Rami Rosen wrote:
> In devcgroup_css_alloc(), there is no longer need for parent_cgroup.
> bd2953ebbb("devcg: propagate local changes down the hierarchy") made
> the variable parent_cgroup redundant. This patch removes parent_cgroup
> from devcgroup_css_alloc().
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
