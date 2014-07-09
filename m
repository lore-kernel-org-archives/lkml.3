Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaGIUPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:15:55 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:37216 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbaGIUPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:15:54 -0400
Date: Wed, 9 Jul 2014 16:15:49 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v3 12/12] cpuset: export effective masks to userspace
Message-ID: <20140709201549.GD21090@htj.dyndns.org>
References: <53BD0174.4060002@huawei.com>
 <53BD0215.8060305@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD0215.8060305@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 04:49:25PM +0800, Li Zefan wrote:
> cpuset.cpus and cpuset.mems are the configured masks, and we need
> to export effective masks to userspace, so users know the real
> cpus_allowed and mems_allowed that apply to the tasks in a cpuset.
> 
> v2:
> - export those masks unconditionally, suggested by Tejun.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

I applied this patch but there's a pending patchset to split legacy
and dfl cftype arrays, so maybe doing it separately makes more sense
now, I'm not sure.  Anyways, we need to review cpuset interface for
the default hierarchy anyway.  At least the memory pressure knobs
should go.  It's measuring something which is completely
implementation dependent.

Thanks.

-- 
tejun
