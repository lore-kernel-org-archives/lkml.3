Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483Ab3KMP1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:27:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47529 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755676Ab3KMP1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:27:49 -0500
Message-ID: <52839A4C.9080601@ti.com>
Date: Wed, 13 Nov 2013 10:27:08 -0500
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
        <galak@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH V3 2/7] DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar
 IP
References: <1383657257-3458-1-git-send-email-r.sricharan@ti.com> <1383657257-3458-3-git-send-email-r.sricharan@ti.com>
In-Reply-To: <1383657257-3458-3-git-send-email-r.sricharan@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 November 2013 08:14 AM, Sricharan R wrote:
> Some socs have a large number of interrupts requests to service
> the needs of its many peripherals and subsystems. All of the
> interrupt lines from the subsystems are not needed at the same
> time, so they have to be muxed to the irq-controller appropriately.
> In such places a interrupt controllers are preceded by an CROSSBAR
> that provides flexibility in muxing the device requests to the controller
> inputs.
> 
> This driver takes care a allocating a free irq and then configuring the
> crossbar IP as a part of the mpu's irqchip callbacks. crossbar_init should
> be called right before the irqchip_init, so that it is setup to handle the
> irqchip callbacks.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> Acked-by: Kumar Gala <galak@codeaurora.org> (for DT binding portion)
> ---
As someone commented already, lets call the driver as irq-crossbar
since there might need of something similar for DMA and IO's.

So rename the code accordingly. Other than that,
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>


