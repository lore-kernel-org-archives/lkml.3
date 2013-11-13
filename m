Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab3KMP2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:28:21 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46929 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab3KMP2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:28:19 -0500
Message-ID: <52839A67.10802@ti.com>
Date: Wed, 13 Nov 2013 10:27:35 -0500
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
Subject: Re: [PATCH V3 3/7] ARM: DTS: DRA: Add crossbar device binding
References: <1383657257-3458-1-git-send-email-r.sricharan@ti.com> <1383657257-3458-4-git-send-email-r.sricharan@ti.com>
In-Reply-To: <1383657257-3458-4-git-send-email-r.sricharan@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 November 2013 08:14 AM, Sricharan R wrote:
> This adds the irq crossbar device node.
> 
> There is a IRQ crossbar device in the soc, which
> maps the irq requests from the peripherals to the
> mpu interrupt controller's inputs. The Peripheral irq
> requests are connected to only one crossbar
> input and the output of the crossbar is connected to only one
> controller's input line. The crossbar device is used to map
> a peripheral input to a free mpu's interrupt controller line.
> 
> Cc: Benoit Cousson <bcousson@baylibre.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

