Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaKXOpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:45:51 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:8710 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbaKXOpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:45:49 -0500
Message-ID: <54734481.1020901@huawei.com>
Date: Mon, 24 Nov 2014 22:45:21 +0800
From: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 01/16] irqdomain: Introduce new interfaces to support
 hierarchy irqdomains
References: <20141112133941.647950773@linutronix.de> <20141112134119.881823615@linutronix.de> <547325A9.3000109@huawei.com> <alpine.DEB.2.11.1411241405560.6439@nanos> <54733A4E.8020304@huawei.com> <alpine.DEB.2.11.1411241525470.6439@nanos>
In-Reply-To: <alpine.DEB.2.11.1411241525470.6439@nanos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/24 22:32, Thomas Gleixner wrote:

> On Mon, 24 Nov 2014, Yun Wu (Abel) wrote:
>> On 2014/11/24 21:13, Thomas Gleixner wrote:
>>> In the hierarchical case we do not touch the hardware in the
>>> allocation step, so we need to activate the allocated interrupt in the
>>> hardware before we can use it. And that's clearly a domain interface
>>> not a irq chip issue.
>>>
>>
>> Makes sense, now the interrupt domain seems to be the best place.
>> And when the @domain parameter can be really useful? I haven't see
>> anyone using it so far.
> 
> All irqdomain callbacks take the domain pointer as their first
> parameter. So for consistency sake we made it that way.
> 
> You can argue in circles about whether the domain argument could be
> removed. It's going to stay for now as it does not matter at all.
> 

Yes, you are right.

Thanks,
	Abel

