Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab3IJTkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:40:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44597 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3IJTkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:40:08 -0400
Message-ID: <522F7591.6010409@baylibre.com>
Date: Tue, 10 Sep 2013 21:40:01 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Nishanth Menon <nm@ti.com>,
        Devicetree Discuss <devicetree@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 0/3] ARM: dts: Enable EDMA, MMC and SPI on AM33XX for
 v3.13
References: <1378841079-15796-1-git-send-email-joelf@ti.com>
In-Reply-To: <1378841079-15796-1-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joel,

Thanks for the repost.

I'll applied that one now.

Regards,
Benoit

On 10/09/2013 21:24, Joel Fernandes wrote:
> Here are last few patches required to add EDMA and MMC/SPI support for AM33xx.
>
> Now that all dependent DMA patches and fixes are in linux next or mainline, except
> for [1] which should go in for 3.12 -rc cycle, it is safe to enable MMC and SPI support
> and this patch series enables it. These are originally Matt Porter's patches with
> changes to make it work with recent kernels, addition of irq, memory resources and
> enable other extra properties.
>
> These patches should cleanly apply on master branch after Koen's patch [2] for basic
> BBB DT support is applied.
>
> MMC support is enabled for: Beaglebone, AM335x EVM and EVM-SK boards. MMC support
> for BBB is intentionally not added due to custom fixes and other patches that are
> in Koen's tree and which will be separately submitted by him.
>
> [1] http://marc.info/?l=linux-omap&m=137883926226451&w=2
> [2] http://comments.gmane.org/gmane.linux.kernel.stable/63648
>
> Matt Porter (3):
>    ARM: dts: add AM33XX EDMA support
>    ARM: dts: add AM33XX SPI DMA support
>    ARM: dts: add AM33XX MMC support and documentation
>
>   .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      | 26 +++++++++-
>   arch/arm/boot/dts/am335x-bone.dts                  | 11 ++++
>   arch/arm/boot/dts/am335x-evm.dts                   |  7 +++
>   arch/arm/boot/dts/am335x-evmsk.dts                 |  7 +++
>   arch/arm/boot/dts/am33xx.dtsi                      | 60 ++++++++++++++++++++++
>   5 files changed, 110 insertions(+), 1 deletion(-)
>

