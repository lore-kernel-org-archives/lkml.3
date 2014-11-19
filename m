Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaKSDio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:38:44 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:28892 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaKSDin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:38:43 -0500
Message-ID: <546C10A1.9040704@huawei.com>
Date: Wed, 19 Nov 2014 11:38:09 +0800
From: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback irq_chip.irq_write_msi_msg
References: <20141112133941.647950773@linutronix.de> <20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com> <alpine.DEB.2.11.1411181103360.3909@nanos> <546B4A91.6080004@huawei.com> <546B4D0D.9050601@linux.intel.com> <546B4F18.5060705@huawei.com> <546B51BA.6070806@linux.intel.com> <546B5635.6020806@huawei.com> <546B57E4.9040804@linux.intel.com> <546B5BAA.9090905@huawei.com> <87a93oe8is.fsf@approximate.cambridge.arm.com>
In-Reply-To: <87a93oe8is.fsf@approximate.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020208.546C10AF.0147,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 7cda737b64402dc602e20b1989e253f2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/19 1:14, Marc Zyngier wrote:

> On Tue, Nov 18 2014 at  2:46:02 pm GMT, "Yun Wu (Abel)" <wuyun.wu@huawei.com> wrote:
[...]
>> IIUC, Marc's patch now only supports PCI MSI/MSI-X...
> 
> Indeed, and the current solution makes is relatively easy to plug in
> non-PCI MSI. Just don't plug the ITS into the *PCI* MSI framework when
> you encounter such a thing.
> 

I am looking forward to that. :)
I guess the main reason you haven't plugged in non-PCI MSI is the way
of obtaining device ids used in searching DT table.

Thanks,
	Abel

