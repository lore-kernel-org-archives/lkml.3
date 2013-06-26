Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3FZRuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:50:16 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:65408 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3FZRuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:50:14 -0400
Date: Wed, 26 Jun 2013 10:50:08 -0700
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: lizefan@huawei.com, LKML <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, trinity@vger.kernel.org
Subject: Re: [PATCH cgroup/for-3.11] cgroup: grab cgroup_mutex in
 drop_parsed_module_refcounts()
Message-ID: <20130626175008.GF4405@mtj.dyndns.org>
References: <51C9D17B.5090208@oracle.com>
 <20130626010454.GD30407@mtj.dyndns.org>
 <20130626010521.GE30407@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626010521.GE30407@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 06:05:21PM -0700, Tejun Heo wrote:
> This isn't strictly necessary as all subsystems specified in
> @subsys_mask are guaranteed to be pinned; however, it does spuriously
> trigger lockdep warning.  Let's grab cgroup_mutex around it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Applied both patches to cgroup/for-3.11.

Thanks.

-- 
tejun
