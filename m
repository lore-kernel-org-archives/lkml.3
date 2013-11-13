Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab3KMPaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:30:23 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47661 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932300Ab3KMPaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:30:18 -0500
Message-ID: <52839AE5.9040906@ti.com>
Date: Wed, 13 Nov 2013 10:29:41 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sricharan R <r.sricharan@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <robherring2@gmail.com>, <tglx@linutronix.de>,
        <galak@codeaurora.org>
Subject: Re: [PATCH V3 6/7] ARM: OMAP4+: Correct Wakeup-gen code to use physical
 irq number
References: <1383657257-3458-1-git-send-email-r.sricharan@ti.com> <1383657257-3458-7-git-send-email-r.sricharan@ti.com>
In-Reply-To: <1383657257-3458-7-git-send-email-r.sricharan@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 November 2013 08:14 AM, Sricharan R wrote:
> The wakeup gen mask/unmask callback uses the irq element of the
> irq_data to setup. The irq is the linux virtual irq number and
> is same as the hardware irq number only when the parent irqchip
> is setup as a legacy domain. When it is used as a linear domain,
> the virtual irqs are allocated dynamically and wakeup gen code
> cannot rely on these numbers to access the irq registers. Instead
> use the hwirq element of the irq_data which represent the physical
> irq number.
> 
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
