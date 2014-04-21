Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaDUSS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:18:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58394 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaDUSSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:18:23 -0400
Message-ID: <535560E9.5040108@wwwdotorg.org>
Date: Mon, 21 Apr 2014 12:18:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Lee Jones <lee.jones@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, Wolfram Sang <wsa@the-dreams.de>
CC: abrestic@chromium.org, dgreid@chromium.org,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] ARM: tegra: Add the EC i2c tunnel to tegra124-venice2
References: <1397757570-19750-1-git-send-email-dianders@chromium.org> <1397757570-19750-8-git-send-email-dianders@chromium.org>
In-Reply-To: <1397757570-19750-8-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 11:59 AM, Doug Anderson wrote:
> This adds the EC i2c tunnel (and devices under it) to the
> tegra124-venice2 device tree.

The series,
Tested-by: Stephen Warren <swarren@nvidia.com>

I can apply this one patch once the other patches in the series are
acked or applied (in order to make sure the DT binding is acceptable to
others).

I guess I'll send separate patches for tegra_defconfig and
multi_v7_defconfig to add the required options once I've applied this,
unless you beat me to it.

> diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts

>  	aliases {
> +		i2c20 = "/spi@0,7000d400/cros-ec@0/i2c-tunnel";

Is that needed? I'd prefer not to add it unless there's a specific
reason. I don't think I2C buses need specific names, do they?
