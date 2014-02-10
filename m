Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaBJTvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:51:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36947 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbaBJTu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:50:59 -0500
Message-ID: <52F92D7E.9030304@ti.com>
Date: Mon, 10 Feb 2014 13:50:22 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>
CC: <bcousson@baylibre.com>, <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: OMAP2+: Fix boot with multi_v7_defconfig
References: <1392055835-6494-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1392055835-6494-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$subject probably needs clarity.
On 02/10/2014 12:10 PM, Roger Quadros wrote:
> The OMAP EHCI controller is not compatible with the EHCI
> platform HCD driver so don't claim that we are.

might want to refer to the change in drivers/usb/host/ehci-platform.c
that created this regression as well.

we also probably want to make better explanation about this issue and
why we think this is the correct fix for it - for example, question
Kevin asked in [1]
> 
> This fixes boot on OMAP platforms with CONFIG_USB_EHCI_HCD_PLATFORM=y
> e.g. multi_v7_defconfig
> 
> Reported-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---

[1] http://marc.info/?t=139204803900004&r=1&w=2

-- 
Regards,
Nishanth Menon
