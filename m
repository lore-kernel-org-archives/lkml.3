Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab3KMP3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:29:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47618 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347Ab3KMP3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:29:47 -0500
Message-ID: <52839AC4.5090103@ti.com>
Date: Wed, 13 Nov 2013 10:29:08 -0500
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
Subject: Re: [PATCH V3 4/7] ARM: DTS: DRA: Replace peripheral interrupt numbers
 with crossbar inputs
References: <1383657257-3458-1-git-send-email-r.sricharan@ti.com> <1383657257-3458-5-git-send-email-r.sricharan@ti.com>
In-Reply-To: <1383657257-3458-5-git-send-email-r.sricharan@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 November 2013 08:14 AM, Sricharan R wrote:
> Now with the crossbar IP in picture, the peripherals do not have the
> fixed interrupt lines. Instead they rely on the crossbar irqchip to
> allocate and map a free interrupt line to its crossbar input. So replacing
> all the peripheral interrupt numbers with its fixed crossbar input lines.
> 
> Cc: Benoit Cousson <bcousson@baylibre.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> ---
>  arch/arm/boot/dts/dra7.dtsi |   86 +++++++++++++++++++++----------------------
>  1 file changed, 43 insertions(+), 43 deletions(-)
> 
You probably need to split the series with dts and drivers/irqchip/*
changes.

For patch itself,
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

