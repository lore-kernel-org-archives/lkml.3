Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaJUIpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:45:09 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:40975 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaJUIpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:45:05 -0400
Message-ID: <54461D08.70106@collabora.co.uk>
Date: Tue, 21 Oct 2014 10:44:56 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH 2/2] ARM: dts: exynos4412-trats: Add suspend configuration
 for max77686 regulators
References: <1413879912-26606-1-git-send-email-k.kozlowski@samsung.com> <1413879912-26606-3-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1413879912-26606-3-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/21/2014 10:25 AM, Krzysztof Kozlowski wrote:
> Add suspend to RAM configuration for max77686 regulators. Some LDOs and
> bucks are disabled. This reduces energy consumption during S2R,
> approximately from 17 mA to 9 mA.
> 
> Additionally remove old and not supported bindings:
>  - regulator-mem-off
>  - regulator-mem-idle
>  - regulator-mem-on
> The max77686 driver does not parse them and they are not documented
> anywere.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4412-trats2.dts | 135 +++++++++++++++++++++++++-------
>  1 file changed, 105 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
> index dd9ac66770f7..c2fbee36021a 100644
> --- a/arch/arm/boot/dts/exynos4412-trats2.dts
> +++ b/arch/arm/boot/dts/exynos4412-trats2.dts

Patch looks good to me.

Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier

