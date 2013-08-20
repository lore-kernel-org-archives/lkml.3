Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab3HTBi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 21:38:29 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:27753 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3HTBi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 21:38:28 -0400
Message-ID: <5212C7DC.3060707@huawei.com>
Date: Tue, 20 Aug 2013 09:35:24 +0800
From: Libin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>,
        <wangyijing@huawei.com>
Subject: Re: [PATCH] workqueue: Correct/Drop references to gcwq in Documentation
References: <1376631197-12028-1-git-send-email-huawei.libin@huawei.com> <20130816144730.GC2505@htj.dyndns.org>
In-Reply-To: <20130816144730.GC2505@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/16 22:47, Tejun Heo wrote:
> On Fri, Aug 16, 2013 at 01:33:17PM +0800, Libin wrote:
>> No functional changes. This patch fixes the post gcwq comments in
>> Documentation/workqueue.txt.
>>
>> Signed-off-by: Libin <huawei.libin@huawei.com>
> 
> Thanks a lot for doing this.  Can you please update the unbound pool
> part accordingly as described in one of the replies?  Also, it'd be
> nice if you bundle these three into a single thread so that the
> patches are easier to track.
> 
> Thanks!
> 

OK, I will update the patchs and post the patch set soon.

Thanks,
Libin

