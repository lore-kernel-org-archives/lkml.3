Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaLJKZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:25:22 -0500
Received: from www.linutronix.de ([62.245.132.108]:52585 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaLJKZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:25:20 -0500
Date: Wed, 10 Dec 2014 11:25:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
cc: Marc Zyngier <marc.zyngier@arm.com>, Jiang Liu <jiang.liu@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback
 irq_chip.irq_write_msi_msg
In-Reply-To: <54880E5C.1040007@huawei.com>
Message-ID: <alpine.DEB.2.11.1412101102420.13233@nanos>
References: <20141112133941.647950773@linutronix.de> <20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com> <alpine.DEB.2.11.1411181103360.3909@nanos> <546B4A91.6080004@huawei.com> <546B4D0D.9050601@linux.intel.com> <546B4F18.5060705@huawei.com>
 <alpine.DEB.2.11.1411181518310.3909@nanos> <546B5904.6020200@huawei.com> <8761ece85x.fsf@approximate.cambridge.arm.com> <546C1148.4080102@huawei.com> <alpine.DEB.2.11.1411191209400.3909@nanos> <54880E5C.1040007@huawei.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014, Yun Wu (Abel) wrote:
> On 2014/11/19 19:11, Thomas Gleixner wrote:
> I spent last two weeks implementing and testing my original idea about making
> the sub domains generic, based on stacked domain feature. Now it comes real,
> please see the attached patch.

Can you please send patches inline? Attached is a pain to reply to.
 
> With this patch applied, I think things will get easier.

I don't see what gets easier. It's just another infrastructure which
is painfully similar to MSI.

> This patch (also with several other patches) is tested on Hisilicon ARM64 SoC,
> with non PCI devices capable of message based interrupts. The PCI part is not
> tested because it needs large refactoring work to do. So yes, the testing work
> is not sufficient, but I think the patch is enough to present what I really
> wanted to express. :)

Not really.

If you provide proper patches which make use of it and most important
a proper refactoring of the PCI/MSI side then we can discuss that, but
for now it's just handwaving.

Thanks,

	tglx





