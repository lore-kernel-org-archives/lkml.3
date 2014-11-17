Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaKQVbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:31:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:35694 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaKQVbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:31:18 -0500
Date: Mon, 17 Nov 2014 22:31:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bjorn Helgaas <bhelgaas@google.com>
cc: Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Subject: Re: [PATCH 00/10] Save MSI chip in pci_sys_data
In-Reply-To: <CAErSpo7hH=v15w2UgG3mWc_B=YQNA-ZXj_VO_9dHZ3oFrk_yjw@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411172230010.3909@nanos>
References: <1414396127-30023-1-git-send-email-wangyijing@huawei.com> <20141112042359.GK28161@google.com> <20141117025914.GC4280@google.com> <alpine.DEB.2.11.1411171035270.3909@nanos> <CAErSpo46d0OJbO6tuDUXb2q7+00BUuHzJdsCr+aOhY4we+zn=w@mail.gmail.com>
 <alpine.DEB.2.11.1411172138191.3909@nanos> <CAErSpo7hH=v15w2UgG3mWc_B=YQNA-ZXj_VO_9dHZ3oFrk_yjw@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Bjorn Helgaas wrote:
> Super.  Thank you very much for taking care of this; it's a big weight
> off my mind.
> 
> You can add my Acked-by to these patches if you want it.  I would
> suggest a minor comment expansion here, just because the code *looks
> like* it's setting up something to match a hardware device:
> 
> > +/**
> > + * pci_msi_domain_calc_hwirq - Generate a unique ID for an MSI source
> > + * @dev:       Pointer to the PCI device
> > + * @desc:      Pointer to the msi descriptor
> > + *
> > + * The ID number is only used within the irqdomain.
> 
> Maybe include something like:
> 
>   This "irq_hw_number_t" is an opaque identifier used only by the
> irqdomain code.
>   It does not correspond to any hardware implementation or register encoding.

Yes, that's really a way better description of it.

Thanks for having a look!

       tglx

