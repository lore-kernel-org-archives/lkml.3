Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197AbaLDV6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:58:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:60686 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709AbaLDV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:58:30 -0500
Date: Thu, 4 Dec 2014 22:58:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stuart Yoder <b08248@gmail.com>
cc: Marc Zyngier <marc.zyngier@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        "Yun Wu (Abel)" <wuyun.wu@huawei.com>
Subject: Re: [PATCH v3 09/13] irqchip: GICv3: ITS: MSI support
In-Reply-To: <CALRxmdAULDXqx5oNUGQx9y2oUegULKO7=gWQWMRkFOzFo9XS8A@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412042257000.16275@nanos>
References: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com> <1416839720-18400-10-git-send-email-marc.zyngier@arm.com> <CALRxmdAULDXqx5oNUGQx9y2oUegULKO7=gWQWMRkFOzFo9XS8A@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2014, Stuart Yoder wrote:
> On Mon, Nov 24, 2014 at 8:35 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> 
> > +/*
> > + * We need a value to serve as a irq-type for LPIs. Choose one that will
> > + * hopefully pique the interest of the reviewer.
> > + */
> > +#define GIC_IRQ_TYPE_LPI               0xa110c8ed
> 
> Ok, my interest is piqued.  Why this value?

Hint: 0x1337

