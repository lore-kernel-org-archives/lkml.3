Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935897Ab3DHUCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:02:39 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:45321 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397Ab3DHUCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:02:37 -0400
Date: Mon, 8 Apr 2013 13:02:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, bsingharora@gmail.com,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter@redhat.com,
        linux-kernel@vger.kernel.org, dhaval.giani@gmail.com,
        workman-devel@redhat.com
Subject: Re: [Workman-devel] cgroup: status-quo and userland efforts
Message-ID: <20130408200232.GM3021@htj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <20130408175925.GE28292@redhat.com>
 <20130408181607.GI3021@htj.dyndns.org>
 <20130408191105.GG28292@redhat.com>
 <20130408192024.GL3021@htj.dyndns.org>
 <20130408194630.GH28292@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408194630.GH28292@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 03:46:31PM -0400, Vivek Goyal wrote:
> It would be good to think more about it. How a user can ensure minimum
> resources to a partition/service. Because in that case at every level
> somebody needs to keep track how much of resources have been committed
> as minimum requirements and more consumers can't be allowed at same level.
> (This sounds like cpu RT time division among various cgroups).

Yes, please take a step back from what we have right now because it
isn't very good.  It's a general policy decision / enforcement problem
and even the policies may change dynamically.  Having a central
authority doesn't automatically solve any of that and it'd be most
likely as limited as existing solutions at the beginning but it allows
for future improvements unlike scattering the solution all over the
place which just digs the hole deeper.

Thanks.

-- 
tejun
