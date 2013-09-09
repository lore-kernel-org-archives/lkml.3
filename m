Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab3IIOSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:18:25 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:50064 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab3IIOSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:18:24 -0400
Date: Mon, 9 Sep 2013 10:18:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Libin <huawei.libin@huawei.com>
Cc: linux-kernel@vger.kernel.org, wangyijing@huawei.com, guohanjun@huawei.com
Subject: Re: [PATCH] workqueue: remove meaningless BUILD_BUG_ON() in
 init_workqueues()
Message-ID: <20130909141820.GF25434@htj.dyndns.org>
References: <1378703400-4536-1-git-send-email-huawei.libin@huawei.com>
 <20130909141302.GC25434@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909141302.GC25434@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 10:13:02AM -0400, Tejun Heo wrote:
> Indeed, but can you please update worker_pool_assign_id() so that it
> doesn't allocate ids >= WORK_OFFQ_POOL_NONE?

So, you did this separately on the next patch.  Can you please roll
that patch into this one with the suggested update?

Thanks.

-- 
tejun
