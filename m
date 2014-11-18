Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbaKROT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:19:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:39299 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbaKROTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:19:53 -0500
Date: Tue, 18 Nov 2014 15:19:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback
 irq_chip.irq_write_msi_msg
In-Reply-To: <546B4F18.5060705@huawei.com>
Message-ID: <alpine.DEB.2.11.1411181518310.3909@nanos>
References: <20141112133941.647950773@linutronix.de> <20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com> <alpine.DEB.2.11.1411181103360.3909@nanos> <546B4A91.6080004@huawei.com> <546B4D0D.9050601@linux.intel.com>
 <546B4F18.5060705@huawei.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:
> On 2014/11/18 21:43, Jiang Liu wrote:
> > 	We provide an irq_chip for each type of interrupt controller
> > instead of devices. For the example mentioned above, if device A
> > and Group B has different interrupt controllers, we just need to
> > implement irq_chip_A and irq_chip_B and set irq_chip.irq_write_msi_msg()
> > to suitable callbacks.
> > 	The framework already achieves what you you want:)
> 
> What if device A and group B have the same interrupt controller?

Well, if write_msg() is different they are hardly the same.

Thanks,

	tglx
