Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbaBLUNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:13:47 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:41904 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbaBLUNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:13:44 -0500
Date: Wed, 12 Feb 2014 15:13:37 -0500
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
Message-ID: <20140212201337.GE26809@htj.dyndns.org>
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
 <52F8A51F.4090909@cn.fujitsu.com>
 <20140210184729.GL4250@linux.vnet.ibm.com>
 <20140212182336.GD5496@localhost.localdomain>
 <20140212190241.GD4250@linux.vnet.ibm.com>
 <20140212192354.GC26809@htj.dyndns.org>
 <20140212195922.GE4250@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212195922.GE4250@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:59:22AM -0800, Paul E. McKenney wrote:
> Documentation/kernel-per-CPU-kthreads.txt: Workqueue affinity
> 
> This commit documents the ability to apply CPU affinity to WQ_SYSFS
> workqueues, thus offloading them from the desired worker CPUs.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
