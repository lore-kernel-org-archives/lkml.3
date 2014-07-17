Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbaGQWmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 18:42:31 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:49260 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaGQWma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 18:42:30 -0400
Message-ID: <53C8514F.4040606@collabora.co.uk>
Date: Fri, 18 Jul 2014 00:42:23 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: Doug Anderson <dianders@chromium.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        sjg@chromium.org, olof@lixom.net, ch.naveen@samsung.com,
        swarren@wwwdotorg.org, khilman@linaro.org, ajaynumb@gmail.com,
        rahul.sharma@samsung.com, tushar.b@samsung.com, ben-linux@fluff.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: dts: Add cros_ec to exynos5420-peach-pit and
 exynos5800-peach-pi
References: <1403627332-4688-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1403627332-4688-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

On 06/24/2014 06:28 PM, Doug Anderson wrote:
> This adds cros_ec to exynos5420-peach-pit and exynos5800-peach-pi,
> including:
> * The keyboard
> * The i2c tunnel
> * The tps65090 under the i2c tunnel
> * The battery under the i2c tunnel
> 
> To add extra motivation, it should be noted that tps65090 is one of
> the things needed to get display-related FETs turned on for pit and
> pi.
> 
> Note that this relies on a few outstanding changes:
> * Needs (spi: s3c64xx: fix broken "cs_gpios" usage in the driver) and
>   (spi: s3c64xx: for DT platofrms always get the chipselect info from
>   DT node) to work properly and match the documented bindings.  See
>   <https://patchwork.kernel.org/patch/4346701/> and
>   <https://patchwork.kernel.org/patch/4346711/>
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Tested-by: Tushar Behera <tushar.b@samsung.com>
> 

Mark Brown as already applied the SPI DT binding fix from Naveen [0] which was
the dependency for this patch and he said that will try to send the whole series
to Torvalds before the 3.16-rc cycle ends.

So I think that it's safe now if you want to pick this patch.

Thanks a lot!

Best regards,
Javier

[0]:
https://git.kernel.org/cgit/linux/kernel/git/broonie/spi.git/commit/?h=for-next&id=306972cedfdedc662dd8e32a6397d0e29f2ac90e
