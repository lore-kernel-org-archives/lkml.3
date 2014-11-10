Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaKJRxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:53:39 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36393 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbaKJRxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:53:37 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+La8EaY4KYBgUAmAc7L3yF
Date: Mon, 10 Nov 2014 09:52:52 -0800
From: Tony Lindgren <tony@atomide.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
Cc: bcousson@baylibre.com, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Add DRA7xx CPSW Ethernet support in Device Tree
Message-ID: <20141110175251.GR31454@atomide.com>
References: <1413885661-4850-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413885661-4850-1-git-send-email-mugunthanvnm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mugunthan V N <mugunthanvnm@ti.com> [141021 03:02]:
> Adding device tree entry for CPSW to make it work in Dual EMAC mode.
> These patches were tested with DRA7 hwmod patches on top of linux-next.
> Patches are tested on top of Nishanth's PM tree for v3.17 [1] and pushed
> my tree to [2].
> 
> Did a boot test with CPSW and ping test with suspend/resume, the boot logs
> on DRA7xx EVM are posted at [3]

Thanks applying into omap-for-v3.19/dt.

Tony
 
> [1] git://github.com/nmenon/linux-2.6-playground.git testing/v3.17/cpu-idle-suspend-dra7-omap5-framework
> [2] git://git.ti.com/~mugunthanvnm/ti-linux-kernel/linux.git v3.17/dra7-evm-cpsw-v3
> [3] http://pastebin.ubuntu.com/8613072/
> 
> Changes from v2:
> * Changed pinctrl comments to hold mode0-name.mode-selected-name
> * Changes slave numbers in the pinctrl comments
> * Added cpsw and cpts clocks
> 
> Changes from initial version:
> * Dropped patch for pinoff states
> * Changed pinoff state to mode15
> 
> Mugunthan V N (2):
>   ARM: dts: dra7: Add CPSW and MDIO module nodes for dra7
>   ARM: dts: dra7-evm: Enable CPSW and MDIO for dra7xx EVM
> 
>  arch/arm/boot/dts/dra7-evm.dts | 106 +++++++++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/dra7.dtsi    |  61 ++++++++++++++++++++++++
>  2 files changed, 167 insertions(+)
> 
> -- 
> 2.1.2.484.g13da0fc
> 
