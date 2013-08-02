Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab3HBLnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 07:43:45 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53599 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3HBLnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 07:43:43 -0400
Date: Fri, 2 Aug 2013 07:42:12 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 03/23] netprio_cgroup: pass around @css instead of
 @cgroup and kill struct cgroup_netprio_state
Message-ID: <20130802114212.GA18116@hmsreliant.think-freely.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375393801-4817-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 05:49:41PM -0400, Tejun Heo wrote:
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
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: David S. Miller <davem@davemloft.net>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

