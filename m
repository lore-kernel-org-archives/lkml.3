Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3BDIyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:54:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39522 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab3BDIyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:54:08 -0500
Message-ID: <510F7773.5060102@ti.com>
Date: Mon, 4 Feb 2013 14:25:15 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: [PATCHv2 0/2] add omap mcspi device tree data
References: <1359967907-26645-1-git-send-email-sourav.poddar@ti.com>
In-Reply-To: <1359967907-26645-1-git-send-email-sourav.poddar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2013 02:21 PM, Sourav Poddar wrote:
> Patch series adds omap5 evm mcspi nodes and pinctrl
> data in omap5.dtsi and omap5-evm.dts files.
>
> Felipe Balbi (1):
>    arm: dts: omap5: add SPI devices to OMAP5 DeviceTree file
>
> Sourav Poddar (1):
>    arm: dts: omap5-evm: Add mcspi data
>
>   arch/arm/boot/dts/omap5-evm.dts |   46 +++++++++++++++++++++++++++++++++++++++
>   arch/arm/boot/dts/omap5.dtsi    |   40 +++++++++++++++++++++++++++++++++
>   2 files changed, 86 insertions(+), 0 deletions(-)
>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
