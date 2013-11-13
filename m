Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab3KMPcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:32:55 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47142 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507Ab3KMPcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:32:52 -0500
Message-ID: <52839B74.4010600@ti.com>
Date: Wed, 13 Nov 2013 21:02:04 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <robherring2@gmail.com>, <tglx@linutronix.de>,
        <galak@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH V3 1/7] DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable
 irqs
References: <1383657257-3458-1-git-send-email-r.sricharan@ti.com> <1383657257-3458-2-git-send-email-r.sricharan@ti.com> <528399B2.8010308@ti.com>
In-Reply-To: <528399B2.8010308@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Wednesday 13 November 2013 08:54 PM, Santosh Shilimkar wrote:
> On Tuesday 05 November 2013 08:14 AM, Sricharan R wrote:
>> In some socs the gic can be preceded by a crossbar IP which
>> routes the peripheral interrupts to the gic inputs. The peripheral
>> interrupts are associated with a fixed crossbar input line and the
>> crossbar routes that to one of the free gic input line.
>>
>> The DT entries for peripherals provides the fixed crossbar input line
>> as its interrupt number and the mapping code should associate this with
>> a free gic input line. This patch adds the support inside the gic irqchip
>> to handle such routable irqs. The routable irqs are registered in a linear
>> domain. The registered routable domain's callback should be implemented
>> to get a free irq and to configure the IP to route it.
>>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Cc: Rajendra Nayak <rnayak@ti.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> Signed-off-by: Sricharan R <r.sricharan@ti.com>
>> ---
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Thanks Santosh. Will repost all with the minor changes suggested.

Regards,
 Sricharan
