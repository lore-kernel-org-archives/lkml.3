Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaJ0UDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:03:20 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57830 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaJ0UDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:03:18 -0400
Message-ID: <544EA4FA.6040704@collabora.co.uk>
Date: Mon, 27 Oct 2014 21:03:06 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
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
Subject: Re: [PATCH 6/8] regulator: max77686: Add external GPIO control
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com> <1414422226-10948-7-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1414422226-10948-7-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/27/2014 04:03 PM, Krzysztof Kozlowski wrote:
> @@ -85,6 +91,9 @@ struct max77686_data {
>  	struct max77686_regulator_data *regulators;
>  	int num_regulators;
>  
> +	/* Array of size num_regulators with GPIOs for external control. */
> +	int *ext_control_gpio;
> +

The integer-based GPIO API is deprecated in favor of the descriptor-based GPIO
interface (Documentation/gpio/consumer.txt). Could you please use the later?

Best regards,
Javier
