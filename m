Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696AbaLKDCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 22:02:20 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:25395 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176AbaLKDCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 22:02:19 -0500
Message-ID: <5489091C.7030405@huawei.com>
Date: Thu, 11 Dec 2014 11:01:48 +0800
From: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Marc Zyngier <marc.zyngier@arm.com>, Jiang Liu <jiang.liu@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        "Yijing Wang" <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback irq_chip.irq_write_msi_msg
References: <20141112133941.647950773@linutronix.de> <20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com> <alpine.DEB.2.11.1411181103360.3909@nanos> <546B4A91.6080004@huawei.com> <546B4D0D.9050601@linux.intel.com> <546B4F18.5060705@huawei.com> <alpine.DEB.2.11.1411181518310.3909@nanos> <546B5904.6020200@huawei.com> <8761ece85x.fsf@approximate.cambridge.arm.com> <546C1148.4080102@huawei.com> <alpine.DEB.2.11.1411191209400.3909@nanos> <54880E5C.1040007@huawei.com> <alpine.DEB.2.11.1412101102420.13233@nanos>
In-Reply-To: <alpine.DEB.2.11.1412101102420.13233@nanos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.54890928.02BC,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 7cda737b64402dc602e20b1989e253f2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/10 18:25, Thomas Gleixner wrote:

> On Wed, 10 Dec 2014, Yun Wu (Abel) wrote:
>> On 2014/11/19 19:11, Thomas Gleixner wrote:
>> I spent last two weeks implementing and testing my original idea about making
>> the sub domains generic, based on stacked domain feature. Now it comes real,
>> please see the attached patch.
> 
> Can you please send patches inline? Attached is a pain to reply to.

Sure, why not.

>  
>> With this patch applied, I think things will get easier.
> 
> I don't see what gets easier. It's just another infrastructure which
> is painfully similar to MSI.

Then please help me feel that pain when I post inline patches, thanks. :)

> 
>> This patch (also with several other patches) is tested on Hisilicon ARM64 SoC,
>> with non PCI devices capable of message based interrupts. The PCI part is not
>> tested because it needs large refactoring work to do. So yes, the testing work
>> is not sufficient, but I think the patch is enough to present what I really
>> wanted to express. :)
> 
> Not really.
> 
> If you provide proper patches which make use of it and most important
> a proper refactoring of the PCI/MSI side then we can discuss that, but
> for now it's just handwaving.
> 

OK, I will start a new thread when I finished PCI/MSI refactoring work.

Thanks,
	Abel

