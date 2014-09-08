Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaIHTe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:34:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52934 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbaIHTem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:34:42 -0400
Date: Mon, 8 Sep 2014 14:34:40 -0500
From: Nishanth Menon <nm@ti.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [resend PATCH 0/3] Add DRA7xx CPSW Ethernet support in Device
 Tree
Message-ID: <20140908193440.GC12150@kahuna>
References: <1410203998-8700-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410203998-8700-1-git-send-email-mugunthanvnm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 00:49-20140909, Mugunthan V N wrote:
> Adding device tree entry for CPSW to make it work in Dual EMAC mode.
> 
> These patches were tested with DRA7 hwmod patches on top of linux-next.
> The patches were already reviewed [1] and has been waiting for cross bar
> and hwmod to be pulled in. Now since all dependent patches has already
> pulled in, so reposting the patches again.
> 
> Patches are tested on linux-next, the boot logs on DRA7xx EVM [2]
> 
> [1] https://lkml.org/lkml/2014/5/13/89
> [2] http://slexy.org/view/s2YqO0Wj9b 

Sorry this is now blocked inside TI. could you explain the testing done
for sleep state? did you attempt sleep mode before testing this?

> 
> Mugunthan V N (3):
>   pinctrl: dra7: dt-bindings: add pin off modes for dra7 SoC
>   arm/dts: dra7xx: Add CPSW and MDIO module nodes for dra7xx
>   arm/dts: dra7xx: Enable CPSW and MDIO for dra7xx EVM
> 
>  arch/arm/boot/dts/dra7-evm.dts    | 107 ++++++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/dra7.dtsi       |  59 +++++++++++++++++++++
>  include/dt-bindings/pinctrl/dra.h |   8 +++
>  3 files changed, 174 insertions(+)
> 
-- 
Regards,
Nishanth Menon
