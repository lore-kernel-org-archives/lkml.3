Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab3FGAGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 20:06:42 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60953 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab3FGAGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 20:06:41 -0400
Date: Thu, 6 Jun 2013 17:06:37 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org
Subject: Re: [PATCH v7 00/11] per-cgroup cpu-stat
Message-ID: <20130607000637.GT5045@htj.dyndns.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369825402-31046-1-git-send-email-glommer@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 03:03:11PM +0400, Glauber Costa wrote:
> I am coming again with this series, hoping this is a better time for you all to
> look at it.
> 
> I am *not* going as far as marking cpuacct deprecated, because I think it
> deserves a special discussion (even though my position in this matter is widely
> known), but all the infrastructure to make it happen is here. But after this,
> it should be a matter of setting a flag (or not).

Things look generally good to me upto patch 6.  Maybe we can combine
"adding cpuacct stats to cpu" and "re-using schedstats" but no strong
opinion.  Peter, what do you think?

Thanks.

-- 
tejun
