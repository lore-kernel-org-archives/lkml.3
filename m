Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaBENMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:12:53 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55983 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbaBENMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:12:51 -0500
Message-ID: <52F23887.9060209@ti.com>
Date: Wed, 5 Feb 2014 18:41:35 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <robherring2@gmail.com>,
        <galak@codeaurora.org>, <rob.herring@calxeda.com>,
        <santosh.shilimkar@ti.com>, <nm@ti.com>, <bcousson@baylibre.com>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH V5 2/4] DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar
 IP
References: <1386066445-28245-1-git-send-email-r.sricharan@ti.com> <1386066445-28245-3-git-send-email-r.sricharan@ti.com> <52D7B2CA.8080902@ti.com> <52EF7D85.5070705@ti.com> <alpine.DEB.2.02.1402041713470.24986@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402041713470.24986@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 February 2014 09:44 PM, Thomas Gleixner wrote:
> On Mon, 3 Feb 2014, Sricharan R wrote:
>>> I already have your reviewed-by tag for the first patch in this series.
>>>
>>> Kevin was pointing out that irqchip maintainer tag is needed for this patch as well
>>> to be merged. We are planning to take this series through arm-soc tree.
>>>
>>> Can i please have your tag for this patch as well ?
> 
> Acked-by-me
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks Thomas.

Kevin,
    I will re-send a branch based on rc1 for this.

Regards,
 Sricharan
