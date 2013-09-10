Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab3IJA0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:26:22 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:5831 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3IJA0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:26:21 -0400
Message-ID: <522E671F.3000403@huawei.com>
Date: Tue, 10 Sep 2013 08:26:07 +0800
From: Libin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <wangyijing@huawei.com>,
        <guohanjun@huawei.com>
Subject: Re: [PATCH] workqueue: remove meaningless BUILD_BUG_ON() in init_workqueues()
References: <1378703400-4536-1-git-send-email-huawei.libin@huawei.com> <20130909141302.GC25434@htj.dyndns.org> <20130909141820.GF25434@htj.dyndns.org>
In-Reply-To: <20130909141820.GF25434@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/9/9 22:18, Tejun Heo wrote:
> On Mon, Sep 09, 2013 at 10:13:02AM -0400, Tejun Heo wrote:
>> Indeed, but can you please update worker_pool_assign_id() so that it
>> doesn't allocate ids >= WORK_OFFQ_POOL_NONE?
> 
> So, you did this separately on the next patch.  Can you please roll
> that patch into this one with the suggested update?

Hello Tejun,
I will update it according to your suggestion.

Thanks!
Libin

> 
> Thanks.
> 



