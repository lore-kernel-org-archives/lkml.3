Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaAGMzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:55:52 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:35457 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaAGMzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:55:45 -0500
Message-ID: <52CBF8EB.6000803@huawei.com>
Date: Tue, 7 Jan 2014 20:54:03 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <edumazet@google.com>, <jasowang@redhat.com>, <horms@verge.net.au>,
        <serge.hallyn@ubuntu.com>, <netdev@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        <kaber@trash.net>, <xemul@openvz.org>, <ebiederm@xmission.com>,
        <linux-kernel@vger.kernel.org>, <jhs@mojatatu.com>,
        <lizefan@huawei.com>, Ding Tianhong <dingtianhong@huawei.com>
Subject: Re: [RFC PATCH net-next 1/4] net: introduce backup_classid to struct
 skbuff
References: <52C62A48.1050604@huawei.com> <20140103.003404.1439874071277993396.davem@davemloft.net>
In-Reply-To: <20140103.003404.1439874071277993396.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/3 13:34, David Miller wrote:
> From: Libo Chen <clbchenlibo.chen@huawei.com>
> Date: Fri, 3 Jan 2014 11:11:04 +0800
> 
>>
>> introduce backup_classid to struct skbuff,
>> we can use it to backup sk_classid when net_ns switch.
>>
>> Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>
> 
> Sorry, no new sk_buff members unless there is absolutely not other
> possible implementation.
> 

I'm kind of banging my head against the wall with this,
but can not think of a better way.

skb_shared_info is the extension for sk_buffer, how about moving into it?

any comments are appreciated!

thanks,
Libo

> sk_buff is too big as-is.
> 
> .
> 


