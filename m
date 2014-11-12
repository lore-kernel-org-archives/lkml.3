Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaKLON2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:13:28 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:56891 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752532AbaKLON1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:13:27 -0500
X-Listener-Flag: 11101
Subject: Re: [patch 00/16] genirq: Hierarchical irq domains and generic MSI
 interrupt code
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>
In-Reply-To: <20141112133941.647950773@linutronix.de>
References: <20141112133941.647950773@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Nov 2014 22:13:20 +0800
Message-ID: <1415801600.17958.6.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 13:42 +0000, Thomas Gleixner wrote:
> This is an extract from Jiangs various patch series which only
> contains the generic irq and MSI parts w/o the x86 specific
> modifications.
> 
> This is roughly what I plan to merge into the generic irq core, so the
> various outstanding patches (irqchip/x86/...) can be based on this.
> 
> It's available from git as well:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/irqdomain
> 
> Note, that branch is not yet exposed to linux-next and subject to
> modifications including rebasing.

Hi,

I checked the branch and it is just plain v3.18-rc4. Is this branch
ready now?

https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/log/?h=irq/irqdomain

Joe.C


