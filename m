Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3JUJSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:18:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55537 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3JUJSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 05:18:31 -0400
Message-ID: <5264F148.7030705@ti.com>
Date: Mon, 21 Oct 2013 14:48:00 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 0/2] ARM: dts: OMAP2+: add i2c aliases
References: <525E8D91.5090400@ti.com> <1381954864-24410-1-git-send-email-nm@ti.com>
In-Reply-To: <1381954864-24410-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 October 2013 01:51 AM, Nishanth Menon wrote:
> Add i2c aliases for OMAP and AM processor dts nodes to ensure proper
> i2c ordering. Based on Benoit's for_13/dts branch[1]
> 
> Changes in V2:
> 	- Following Rajendra's suggestion, done for all OMAP and AM
> 	  series SoCs, where i2c is defined.

Thanks Nishanth.
Acked-by: Rajendra Nayak <rnayak@ti.com>

> 
> V1: https://patchwork.kernel.org/patch/3046671/
> 
> Nishanth Menon (2):
>   ARM: dts: OMAP3+: Add i2c aliases
>   ARM: dts: AM33xx+: Add i2c aliases
> 
>  arch/arm/boot/dts/am33xx.dtsi |    3 +++
>  arch/arm/boot/dts/am4372.dtsi |    3 +++
>  arch/arm/boot/dts/dra7.dtsi   |    5 +++++
>  arch/arm/boot/dts/omap3.dtsi  |    3 +++
>  arch/arm/boot/dts/omap4.dtsi  |    4 ++++
>  arch/arm/boot/dts/omap5.dtsi  |    5 +++++
>  6 files changed, 23 insertions(+)
> 
> [1] https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.13/dts
> 

