Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab3HMPCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:02:52 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:53386 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab3HMPCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:02:49 -0400
Date: Tue, 13 Aug 2013 11:02:45 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: decouple cgroup_subsys_state
 lifetime from that of cgroup
Message-ID: <20130813150245.GE26596@mtj.dyndns.org>
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375992831-4650-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 04:13:37PM -0400, Tejun Heo wrote:
> With the planned unified hierarchy, we'll be dynamically creating and
> destroying css's through the lifetime of a cgroup, so we can no longer
> hitch css lifetime management onto cgroup's.  This patchset separates
> out css lifetime management from that of cgroup.  After the patchset,
> each css is individually RCU protected.

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
