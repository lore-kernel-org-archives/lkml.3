Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab3HAWHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:07:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54926 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab3HAWHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:07:49 -0400
Date: Thu, 01 Aug 2013 15:07:47 -0700 (PDT)
Message-Id: <20130801.150747.1331605394989816099.davem@davemloft.net>
To: tj@kernel.org
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        nhorman@tuxdriver.com
Subject: Re: [PATCH 03/23] netprio_cgroup: pass around @css instead of
 @cgroup and kill struct cgroup_netprio_state
From: David Miller <davem@davemloft.net>
In-Reply-To: <1375393801-4817-4-git-send-email-tj@kernel.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
	<1375393801-4817-4-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 01 Aug 2013 15:07:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Thu,  1 Aug 2013 17:49:41 -0400

> cgroup controller API will be converted to primarily use struct
> cgroup_subsys_state instead of struct cgroup.  In preparation, make
> the internal functions of netprio_cgroup pass around @css instead of
> @cgrp.
> 
> While at it, kill struct cgroup_netprio_state which only contained
> struct cgroup_subsys_state without serving any purpose.  All functions
> are converted to deal with @css directly.
> 
> This patch shouldn't cause any behavior differences.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
