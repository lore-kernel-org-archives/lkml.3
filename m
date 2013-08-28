Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3H1M0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:26:22 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:58653 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab3H1M0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:26:19 -0400
Date: Wed, 28 Aug 2013 08:26:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@freescale.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-next@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH linux-next] cgroup: fix warning in css_from_id()
Message-ID: <20130828122615.GB18348@mtj.dyndns.org>
References: <1377691485-26013-1-git-send-email-vincent.stehle@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377691485-26013-1-git-send-email-vincent.stehle@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 02:04:45PM +0200, Vincent Stehlé wrote:
> Commit ca8bdcaff0d77990fb69e0f946018c96a70851cc changes cgroup_css() second
> argument type; update css_from_id() accordingly.
> 
> This fixes the following compilation warning:
> 
>   kernel/cgroup.c: In function 'css_from_id':
>   kernel/cgroup.c:5723:3: warning: passing argument 2 of 'cgroup_css' makes pointer from integer without a cast [enabled by default]
>   kernel/cgroup.c:237:36: note: expected 'struct cgroup_subsys *' but argument is of type 'int'
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>

Fixed up yesterday in cgroup/for-3.12 branch.  Today's next should be
okay.

Thanks.

-- 
tejun
