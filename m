Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3L3CRO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 21:17:14 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:55425 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab3L3CRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 21:17:12 -0500
Message-ID: <52C0D6F7.2020301@huawei.com>
Date: Mon, 30 Dec 2013 10:14:15 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Ding Tianhong <dthxman@gmail.com>
CC: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 20/20] net: caif: slight optimization of addr
 compare
References: <52BE6D50.9000308@huawei.com>	 <1388213953.24123.2.camel@joe-AO722> <52BEE7F0.1070506@gmail.com> <1388250271.24123.4.camel@joe-AO722>
In-Reply-To: <1388250271.24123.4.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/29 1:04, Joe Perches wrote:
> On Sat, 2013-12-28 at 23:02 +0800, Ding Tianhong wrote:
>> 于 2013/12/28 14:59, Joe Perches 写道:
>>> On Sat, 2013-12-28 at 14:18 +0800, Ding Tianhong wrote:
>>>> Use possibly more efficient ether_addr_equal
>>>> to instead of memcmp.
>>>
>>> This may be a distinction without difference, but
>>> is a CAIF seghead also an ethernet address?
>>>
>> NO，this is a coincidence, the CAIF seghead is 6 bytes too,
>> So from a logical point of view, maybe a new function with
>> suitable name will be more reasonable here, but the name of
>> ether_addr_equal is not correctly here.:)
> 
> So please remove this one from the series.
> 
> 

Yes, Ok!

Regards
Ding
> 
> 


