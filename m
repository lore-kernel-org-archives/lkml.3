Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab3FFBth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:49:37 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:34887 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3FFBtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:49:36 -0400
Date: Wed, 5 Jun 2013 18:49:29 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org
Subject: Re: [PATCH v7 00/11] per-cgroup cpu-stat
Message-ID: <20130606014929.GS10693@mtj.dyndns.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369825402-31046-1-git-send-email-glommer@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Wed, May 29, 2013 at 03:03:11PM +0400, Glauber Costa wrote:
> I am *not* going as far as marking cpuacct deprecated, because I think it
> deserves a special discussion (even though my position in this matter is widely
> known), but all the infrastructure to make it happen is here. But after this,
> it should be a matter of setting a flag (or not).

I'll ensure that cpuacct can't be used with sane_behavior from cgroup
core side, so that it can be deprecated with multiple hierarchies
eventually.

> Through this patchset I am making cpu cgroup provide the same functionality of
> cpuacct, and now with a more clear semantics, I attempt to provide userspace
> with enough information to reconstruct per-container version of files like
> "/proc/stat". In particular, we are interested in knowing the per-cgroup slices
> of user time, system time, wait time, number of processes, and a variety of
> statistics.
> 
> To make sure we can count nr of switches correctly, I am ressurecting one of
> Peter's patches that apparently got nowhere in the past.

I generally agree with the approach but which tree is it based on?
Can you please let me know the base commit so that I can review the
series properly?

Thanks.

-- 
tejun
