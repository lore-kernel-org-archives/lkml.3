Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbaGOHU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 03:20:26 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:40169 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751210AbaGOHUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 03:20:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/2MhQPKwJcgtiJG/PRsPtd
Date: Tue, 15 Jul 2014 00:18:59 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [RESEND PATCH 0/8] arm: dts: dra7: Add PCIe data and PCIe PHY
 data
Message-ID: <20140715071859.GL20068@atomide.com>
References: <1405334543-25509-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405334543-25509-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kishon Vijay Abraham I <kishon@ti.com> [140714 03:44]:
> [1] is split into separate series in order for individual subsystem
> Maintainers to pick up the patches. This series handles the PCIe
> dt data for DRA7.
> 
> This series has better commit logs than the previous one modified as
> suggested by Tero.
> 
> [1] -> https://lkml.org/lkml/2014/5/29/258
> 
> Keerthy (2):
>   ARM: dts: dra7xx-clocks: Add divider table to optfclk_pciephy_div
>     clock
>   ARM: dts: dra7xx-clocks: Change the parent of apll_pcie_in_clk_mux to
>     dpll_pcie_ref_m2ldo_ck
> 
> Kishon Vijay Abraham I (6):
>   ARM: dts: dra7xx-clocks: Add missing 32KHz clocks used for PHY
>   ARM: dts: dra7xx-clocks: rename pcie clocks to accommodate second PHY
>     instance
>   ARM: dts: dra7xx-clocks: Add missing clocks for second PCIe PHY
>     instance
>   ARM: dts: dra7: Add dt data for PCIe PHY control module
>   ARM: dts: dra7: Add dt data for PCIe PHY
>   ARM: dts: dra7: Add dt data for PCIe controller
> 
>  arch/arm/boot/dts/dra7.dtsi          |  127 ++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/dra7xx-clocks.dtsi |   39 ++++++++++-
>  2 files changed, 163 insertions(+), 3 deletions(-)

Applying this series into omap-for-v3.17/dt thanks.

Tony
