Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3FFXAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 19:00:18 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:56900 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3FFXAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 19:00:15 -0400
Date: Thu, 6 Jun 2013 16:00:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH v7 04/11] sched: adjust exec_clock to use it as cpu usage
 metric
Message-ID: <20130606230012.GN5045@htj.dyndns.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
 <1369825402-31046-5-git-send-email-glommer@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369825402-31046-5-git-send-email-glommer@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 03:03:15PM +0400, Glauber Costa wrote:
> exec_clock already provides per-group cpu usage metrics, and can be
> reused by cpuacct in case cpu and cpuacct are comounted.
> 
> However, it is only provided by tasks in fair class. Doing the same for
> rt is easy, and can be done in an already existing hierarchy loop. This
> is an improvement over the independent hierarchy walk executed by
> cpuacct.
> 
> Signed-off-by: Glauber Costa <glommer@openvz.org>
> CC: Dave Jones <davej@redhat.com>
> CC: Ben Hutchings <ben@decadent.org.uk>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Paul Turner <pjt@google.com>
> CC: Lennart Poettering <lennart@poettering.net>
> CC: Kay Sievers <kay.sievers@vrfy.org>
> CC: Tejun Heo <tj@kernel.org>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
