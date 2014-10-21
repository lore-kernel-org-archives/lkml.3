Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbaJUNdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:33:44 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41343 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507AbaJUNdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:33:42 -0400
Message-ID: <544660AE.8030903@collabora.co.uk>
Date: Tue, 21 Oct 2014 15:33:34 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v3 1/4] regulator: max77686: Replace hard-coded opmode
 values with defines
References: <1413897595-28752-1-git-send-email-k.kozlowski@samsung.com> <1413897595-28752-2-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1413897595-28752-2-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/21/2014 03:19 PM, Krzysztof Kozlowski wrote:
> Add defines for regulator operating modes which should be more readable,
> especially if one does not have Maxim 77686 datasheet.
> 
> The patch does not introduce any functional change.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Suggested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  drivers/regulator/max77686.c | 34 +++++++++++++++++++++++++++-------
>  1 file changed, 27 insertions(+), 7 deletions(-)
> 

Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier
