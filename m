Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaEDTSQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 15:18:16 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:48941 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaEDTSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 15:18:14 -0400
Date: Sun, 4 May 2014 15:18:11 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        mhocko@suse.cz, nasa4836@gmail.com
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement css->id
Message-ID: <20140504191811.GB26279@htj.dyndns.org>
References: <1398373333-1521-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398373333-1521-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 05:02:07PM -0400, Tejun Heo wrote:
> Hello,
> 
> Until now, cgroup->id has been used to identify all the associated
> csses and css_from_id() takes cgroup ID and returns the matching css
> by looking up the cgroup and then dereferencing the css associated
> with it; however, now that the lifetimes of cgroup and css are
> separate, this is incorrect and breaks on the unified hierarchy when a
> controller is disabled and enabled back again before the previous
> instance is released.

Aplied to cgroup/for-3.16.  I was a bit worried about possible
conflicts with other memcg changes but they don't seem to conflict
anywhere.

Thanks.

-- 
tejun
