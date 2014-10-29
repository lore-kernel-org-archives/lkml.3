Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbaJ2LfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:35:07 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60099 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529AbaJ2LfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:35:04 -0400
Message-ID: <5450D0E1.7040904@collabora.co.uk>
Date: Wed, 29 Oct 2014 12:34:57 +0100
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
Subject: Re: [PATCH v6 2/3] regulator: max77802: Remove suspend_enable
References: <1414581294-1315-1-git-send-email-k.kozlowski@samsung.com> <1414581294-1315-3-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1414581294-1315-3-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/29/2014 12:14 PM, Krzysztof Kozlowski wrote:
> The Maxim 77802 PMIC regulators do not have special enable configuration
> for suspend. The driver instead enabled them manually which is not a
> best way to deal with suspend.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/regulator/max77802.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
> index 5839c4509e1f..b9958d927297 100644
> --- a/drivers/regulator/max77802.c
> +++ b/drivers/regulator/max77802.c

After what Mark explained, I understand this is the right thing to do.

Acked-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier
