Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbaIWQ3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:29:22 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:44196 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbaIWQ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:29:19 -0400
Message-ID: <54219FD5.4030601@samsung.com>
Date: Wed, 24 Sep 2014 01:29:09 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v2] ARM: dts: Add Maxim 77693 PMIC to the Trats2 board
References: <1410793564-30445-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1410793564-30445-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/14 00:06, Krzysztof Kozlowski wrote:
> The MAX77693 is a companion power management IC for smart phones and tablets.
>
> The MAX77693 contains input over-voltage protection (OVP),
> a fully-integrated 2.5A switching charger for Lithium Ion battery with
> integrated battery disconnect, OTG/accessory 5V output power,
> a high-current white LED driver for camera flash, two safeout LDOs,
> a haptic motor driver, Model Gauge m3 battery fuel gauge and MicroUSB
> Interface Controller (MUIC). I2C serial interface is used for
> communicating.
>
> Add MAX77693 node to the Trats2 board. This allows using:
>   - charger regulator,
>   - 2 safeout LDO regulators (for USB OTG),
>   - extcon.
>
> Signed-off-by: Krzysztof Kozlowski<k.kozlowski@samsung.com>
> Reviewed-by: Javier Martinez Canillas<javier.martinez@collabora.co.uk>
>
> ---
>
> Changes since v1:
> ==================
> 1. Use GPIO_ACTIVE_HIGH for gpio flags (suggested by Javier Martinez
>     Canillas).
> 2. Use regulator node name instead of deprecated regulator-compatible
>     property (suggested by Javier Martinez Canillas).
> 3. Add Javier Martinez Canillas' reviewed-by tag.
> ---
>   arch/arm/boot/dts/exynos4412-trats2.dts | 32 ++++++++++++++++++++++++++++++++
>   1 file changed, 32 insertions(+)
>

Looks good to me, applied.

Thanks,
Kukjin
