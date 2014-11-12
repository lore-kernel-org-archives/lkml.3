Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaKLOtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:49:02 -0500
Received: from www.linutronix.de ([62.245.132.108]:42037 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaKLOtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:49:01 -0500
Date: Wed, 12 Nov 2014 15:48:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 00/16] genirq: Hierarchical irq domains and generic MSI
 interrupt code
In-Reply-To: <1415801600.17958.6.camel@mtksdaap41>
Message-ID: <alpine.DEB.2.11.1411121547350.3935@nanos>
References: <20141112133941.647950773@linutronix.de> <1415801600.17958.6.camel@mtksdaap41>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014, Yingjoe Chen wrote:
> On Wed, 2014-11-12 at 13:42 +0000, Thomas Gleixner wrote:
> > This is an extract from Jiangs various patch series which only
> > contains the generic irq and MSI parts w/o the x86 specific
> > modifications.
> > 
> > This is roughly what I plan to merge into the generic irq core, so the
> > various outstanding patches (irqchip/x86/...) can be based on this.
> > 
> > It's available from git as well:
> > 
> >     git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/irqdomain
> > 
> > Note, that branch is not yet exposed to linux-next and subject to
> > modifications including rebasing.
> 
> Hi,
> 
> I checked the branch and it is just plain v3.18-rc4. Is this branch
> ready now?
> 
> https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/log/?h=irq/irqdomain

It's in the master repository so it should be propagated towards the
public interfaces soon.

Thanks,

	tglx
