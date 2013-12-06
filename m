Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3LFHMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:12:06 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:2636 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3LFHMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:12:03 -0500
Message-ID: <52A17898.1090004@huawei.com>
Date: Fri, 6 Dec 2013 15:11:20 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <macro@linux-mips.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>
Subject: Re: [PATCH 2/2] net/fddi: Replace local marco with PCI standard macro
References: <1386243482-32856-1-git-send-email-wangyijing@huawei.com>	<alpine.LFD.2.10.1312052154190.1599@eddie.linux-mips.org>	<52A13F34.2010403@huawei.com> <20131205.234420.2000965496889063263.davem@davemloft.net>
In-Reply-To: <20131205.234420.2000965496889063263.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/6 12:44, David Miller wrote:
> From: Yijing Wang <wangyijing@huawei.com>
> Date: Fri, 6 Dec 2013 11:06:28 +0800
> 
>> On 2013/12/6 6:06, Maciej W. Rozycki wrote:
>>> On Thu, 5 Dec 2013, Yijing Wang wrote:
>>>
>>>> Replace local marco DFX_BUS_PCI with PCI standard marco
>>>> dev_is_pci().
>>>
>>>  Typos above: marco -> macro
>>
>> Sorry for the mistake, David, should i need to resend this patch to fix this typo error?
> 
> You have to resubmit all of these conversions again because you posted
> them before the net-next tree was even open for submissions.
> 
> So you might as well fix the typos etc. while doing so.
> 
> 

OK, I have resent the two refreshed patches.


Thanks!
Yijing.


-- 
Thanks!
Yijing

