Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3IQBBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 21:01:20 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:5504 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3IQBBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 21:01:17 -0400
Message-ID: <5237A9B0.2070507@huawei.com>
Date: Tue, 17 Sep 2013 09:00:32 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, "Hugh Dickins" <hughd@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/mempolicy: use NUMA_NO_NODE
References: <5236FF32.60503@huawei.com> <5237695F.6010501@linux.vnet.ibm.com>
In-Reply-To: <5237695F.6010501@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/9/17 4:26, Cody P Schafer wrote:

> 
>> @@ -1802,11 +1802,11 @@ static inline unsigned interleave_nid(struct mempolicy *pol,
>>
>>   /*
>>    * Return the bit number of a random bit set in the nodemask.
>> - * (returns -1 if nodemask is empty)
>> + * (returns NUMA_NO_NOD if nodemask is empty)
> 
> s/NUMA_NO_NOD/NUMA_NO_NODE/

> 

Thanks, I will resent this.

>>    */
>>   int node_random(const nodemask_t *maskp)
>>   {
>> -    int w, bit = -1;
>> +    int w, bit = NUMA_NO_NODE;
>>
>>       w = nodes_weight(*maskp);
>>       if (w)
>>
> 
> 
> 



