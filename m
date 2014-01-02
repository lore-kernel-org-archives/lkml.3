Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750853AbaABK17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:27:59 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:12903 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaABK16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:27:58 -0500
Message-ID: <52C53EC6.30902@huawei.com>
Date: Thu, 2 Jan 2014 18:26:14 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Joe Perches <joe@perches.com>, Jay Vosburgh <fubar@us.ibm.com>,
        Veaceslav Falico <vfalico@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND net-next 1/7] bonding: use ether_addr_equal_unaligned
 for bond addr compare
References: <52C4BD16.5010702@huawei.com> <alpine.DEB.2.02.1401020839000.2182@localhost6.localdomain6> <52C52180.2030707@huawei.com> <alpine.DEB.2.02.1401020937490.2182@localhost6.localdomain6> <52C52AAD.8040603@huawei.com> <alpine.DEB.2.02.1401021011400.2182@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1401021011400.2182@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/2 17:14, Julia Lawall wrote:
> On Thu, 2 Jan 2014, Ding Tianhong wrote:
> 
>> On 2014/1/2 16:38, Julia Lawall wrote:
>>> On Thu, 2 Jan 2014, Ding Tianhong wrote:
>>>
>>>> On 2014/1/2 15:39, Julia Lawall wrote:
>>>>> Are the casts needed
>>>>
>>>>
>>>> Yes, otherwise the warming will report:
>>>>
>>>> /net-next/drivers/net/bonding/bond_3ad.c:427: warning: passing argument 1 of ‘ether_addr_equal_64bits’ from incompatible pointer type
>>>
>>> Is it necessary for this driver to use a different type from everyone 
>>> else?
>>>
>>> julia
>>>
>> Did you mean the MAC_ADDRESS_EQUAL is excess?
>> I did not remove it because the codes no need to be changed more and it looks that didn't take any negative effect.
> 
> No, I was wondering about the mac_addr type, defined in bond_3ad.h.  Other 
> code just has the array inlined into the containing structure.
> 
> julia
> 

Oh, sorry for mismatch.:)
The code for bond_3ad mode is too old and the use for mac addr is not so comfortable.

I think I need to send a patch to fix the unusual mac addr and make it more reasonable.

Thanks for your opinion.

Regards
Ding 

