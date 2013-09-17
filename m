Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3IQA7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 20:59:47 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:21161 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab3IQA7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 20:59:44 -0400
Message-ID: <5237A967.2060108@huawei.com>
Date: Tue, 17 Sep 2013 08:59:19 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, "Hugh Dickins" <hughd@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/mempolicy: use NUMA_NO_NODE
References: <5236FF32.60503@huawei.com> <52372F9A.1080102@gmail.com>
In-Reply-To: <52372F9A.1080102@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/9/17 0:19, KOSAKI Motohiro wrote:

> (9/16/13 8:53 AM), Jianguo Wu wrote:
>> Use more appropriate NUMA_NO_NODE instead of -1
>>
>> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
>> ---
>>   mm/mempolicy.c |   10 +++++-----
>>   1 files changed, 5 insertions(+), 5 deletions(-)
> 
> I think this patch don't make any functional change, right?
> 

Yes.

> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thanks for your ack.

> 
> 
> 
> 



