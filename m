Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab3KMPaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:30:08 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47008 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab3KMPaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:30:04 -0500
Message-ID: <52839AD5.9090600@ti.com>
Date: Wed, 13 Nov 2013 10:29:25 -0500
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
        <galak@codeaurora.org>, Benoit Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH V3 5/7] ARM: DTS: DRA7: Add routable-irqs property for
 gic node
References: <1383657257-3458-1-git-send-email-r.sricharan@ti.com> <1383657257-3458-6-git-send-email-r.sricharan@ti.com>
In-Reply-To: <1383657257-3458-6-git-send-email-r.sricharan@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 November 2013 08:14 AM, Sricharan R wrote:
> There is a IRQ crossbar device in the soc, which maps the
> irq requests from the peripherals to the mpu interrupt
> controller's inputs. The gic provides the support for such
> IPs in the form of routable-irqs. So adding the property
> here to gic node.
> 
> Cc: Benoit Cousson <bcousson@baylibre.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

