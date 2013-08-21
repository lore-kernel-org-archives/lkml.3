Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3HUOyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:54:25 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:43686 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3HUOyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:54:23 -0400
Message-ID: <5214D49B.9070600@baylibre.com>
Date: Wed, 21 Aug 2013 16:54:19 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, tony@atomide.com
CC: balbi@ti.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        linux@arm.linux.org.uk, javier.martinez@collabora.co.uk,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 0/5]  ARM: OMAP: DTS/HWMOD/defconfig changes for USB3
References: <1377095494-15380-1-git-send-email-kishon@ti.com>
In-Reply-To: <1377095494-15380-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 21/08/2013 16:31, Kishon Vijay Abraham I wrote:
> From: Felipe Balbi <balbi@ti.com>
>
> With these patches (plus a few others on the driver side which
> will be going upstream soon) I could get functional USB3 with my
> omap5-uevm platform.
>
> Changes since v2:
> 	- added dt properties for enabling vbus/id interrupts and fixed
> vbus-supply value after SMPS10 is modeled as 2 regulators

Excellent, thanks for that super quick update. I've just applied it and 
will try to push it ASAP.
I've just slightly changed the subjects to have both ARM and OMAP in 
capital letters for consistency.

Tony,

I will update my pull-request now before Kevin and Olof pulled it.

Regards,
Benoit


> Changes since v1:
> 	- split ocp2scp dts and hwmod data into separate patches
> 	- reorganize the series in order to group DTS, hwmod and defconfig
> 	  changes
>
> Benoit Cousson (1):
>    arm: omap5: hwmod: add missing ocp2scp hwmod data
>
> Felipe Balbi (4):
>    arm: omap5: dts: fix reg property size
>    arm: omap5: dts: fix ocp2scp DTS data
>    arm: omap5: dts: add palmas-usb node
>    arm: omap2plus_defconfig: enable dwc3 and dependencies
>
>   arch/arm/boot/dts/omap5-uevm.dts           |   12 ++++++++
>   arch/arm/boot/dts/omap5.dtsi               |    9 +++---
>   arch/arm/configs/omap2plus_defconfig       |    9 ++++++
>   arch/arm/mach-omap2/omap_hwmod_54xx_data.c |   45 ++++++++++++++++++++++++++++
>   4 files changed, 71 insertions(+), 4 deletions(-)
>

