Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaGaSls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 14:41:48 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45074 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaGaSlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 14:41:46 -0400
Message-ID: <53DA8DE1.10601@samsung.com>
Date: Fri, 01 Aug 2014 03:41:37 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
CC: linux-samsung-soc@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        open list <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Doug Anderson <dianders@chromium.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/4] ARM: dts: Fix MMC pinctrl for exynos5250-snow
References: <1406822910-6255-1-git-send-email-afaerber@suse.de> <1406822910-6255-2-git-send-email-afaerber@suse.de>
In-Reply-To: <1406822910-6255-2-git-send-email-afaerber@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 01:08, Andreas Färber wrote:
> The pinctrl properties should be on the device directly and not on the
> slot sub-node.
>
> Reported-by: Doug Anderson<dianders@chromium.org>
> Cc: Jaehoon Chung<jh80.chung@samsung.com>
> Signed-off-by: Andreas Färber<afaerber@suse.de>
> ---
>   v3 ->  v4: Unchanged
>
>   v3: New (Doug Anderson)
>   Redundant with Jaehoon Chung's general slot@0 deprecation,
>   in case that hits the tree earlier.
>
>   arch/arm/boot/dts/exynos5250-snow.dts | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> index f2b8c4116541..eb437f6afec1 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -240,10 +240,8 @@
>   	 */
>   	mmc@12230000 {
>   		status = "okay";
> -		slot@0 {
> -			pinctrl-names = "default";
> -			pinctrl-0 =<&sd3_clk&sd3_cmd&sd3_bus4>;
> -		};
> +		pinctrl-names = "default";
> +		pinctrl-0 =<&sd3_clk&sd3_cmd&sd3_bus4>;
>   	};
>
>   	i2c@12CD0000 {

Once I get Doug's reviewed tag on exynos5250-snow dt changes, I will 
take this series :) Though Doug suggested or reported...

Thanks,
Kukjin
