Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab3GDErF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 00:47:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:32787 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab3GDErD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 00:47:03 -0400
Message-ID: <51D4FE20.6000805@ti.com>
Date: Thu, 4 Jul 2013 10:16:24 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <nm@ti.com>
Subject: Re: [PATCH v3 2/8] wlcore: set irq_flags in the board files instead
 of hiding behind a quirk
References: <1372860209-3504-1-git-send-email-coelho@ti.com> <1372860209-3504-3-git-send-email-coelho@ti.com>
In-Reply-To: <1372860209-3504-3-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/3/2013 7:33 PM, Luciano Coelho wrote:
> The platform_quirk element in the platform data was used to change the
> way the IRQ is triggered.  When set, the EDGE_IRQ quirk would change
> the irqflags used and treat edge trigger differently from the rest.
> 
> Instead of hiding this irq flag setting behind the quirk, have the
> board files set the flags during initialization.  This will be more
> meaningful than driver-specific quirks when we switch to DT.
> 
> Additionally, fix missing gpio_request() calls in the boarding files
> (so that setting the flags actually works).
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>  arch/arm/mach-davinci/board-da850-evm.c      |    8 +++++-

For the board-da850-evm.c change,

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
