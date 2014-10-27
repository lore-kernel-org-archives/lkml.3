Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaJ0NkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:40:08 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57354 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbaJ0NkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:40:05 -0400
Message-ID: <544E4B25.7080503@collabora.co.uk>
Date: Mon, 27 Oct 2014 14:39:49 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v5 3/4] regulator: max77686: Add suspend disable for some
 LDOs
References: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com> <1414411911-5539-4-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1414411911-5539-4-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/27/2014 01:11 PM, Krzysztof Kozlowski wrote:
> Some LDOs of Maxim 77686 PMIC support disabling during system suspend
> (LDO{2,6,7,8,10,11,12,14,15,16}). This was already implemented as part
> of set_suspend_mode function. In that case the mode was one of:
>  - disable,
>  - normal mode,
>  - low power mode.
> However there are no bindings for setting the mode during suspend.
> 
> Add suspend disable for LDO regulators supporting this. Re-use existing
> max77686_buck_set_suspend_disable() function. This helps reducing
> energy consumption during system sleep.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/regulator/max77686.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
> index 2ebc4257425b..c6bf6f79bd2a 100644
> --- a/drivers/regulator/max77686.c
> +++ b/drivers/regulator/max77686.c

Looks good to me.

Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier

