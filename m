Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbaLDVwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:52:11 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:65337 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaLDVwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:52:09 -0500
MIME-Version: 1.0
In-Reply-To: <1416839720-18400-10-git-send-email-marc.zyngier@arm.com>
References: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com>
	<1416839720-18400-10-git-send-email-marc.zyngier@arm.com>
Date: Thu, 4 Dec 2014 15:52:08 -0600
Message-ID: <CALRxmdAULDXqx5oNUGQx9y2oUegULKO7=gWQWMRkFOzFo9XS8A@mail.gmail.com>
Subject: Re: [PATCH v3 09/13] irqchip: GICv3: ITS: MSI support
From: Stuart Yoder <b08248@gmail.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 8:35 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:

> +/*
> + * We need a value to serve as a irq-type for LPIs. Choose one that will
> + * hopefully pique the interest of the reviewer.
> + */
> +#define GIC_IRQ_TYPE_LPI               0xa110c8ed

Ok, my interest is piqued.  Why this value?

Stuart
