Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbaDOWFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:05:50 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:36000 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDOWFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:05:49 -0400
Date: Tue, 15 Apr 2014 18:05:45 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0.5/12] cgroup: cgroup_apply_cftypes() shouldn't skip the
 default hierarhcy
Message-ID: <20140415220545.GB13099@mtj.dyndns.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
 <20140415220504.GA13099@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415220504.GA13099@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 06:05:04PM -0400, Tejun Heo wrote:
> From c7596b2f33e9f7a57cef6909c30fec268e921c3b Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 15 Apr 2014 18:02:12 -0400
> 
> cgroup_apply_cftypes() skip creating or removing files if the
> subsystem is attached to the default hierarchy, which led to missing
> files in the root of the default hierarchy.
> 
> Skipping made sense when the default hierarchy was dummy; however, now
> that the default hierarchy is full functional and planned to be used
> as the unified hierarchy, it shouldn't be skipped over.
> 
> Reported-by: Li Zefan <lizefan@huawei.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Ugh... wrong thread.  Will repost.

thanks.

-- 
tejun
