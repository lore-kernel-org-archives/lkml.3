Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaGHC3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 22:29:47 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1360 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaGHC3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 22:29:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 07 Jul 2014 19:19:02 -0700
Message-ID: <53BB5797.1090105@nvidia.com>
Date: Tue, 8 Jul 2014 11:29:43 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2] power: poweroff: gpio: convert to use descriptors
References: <1404729272-17873-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1404729272-17873-1-git-send-email-linus.walleij@linaro.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 07:34 PM, Linus Walleij wrote:
> This switches the GPIO poweroff driver to use GPIO descriptors
> rather than numeral GPIOs. We get rid of the specific inversion
> handling as GPIO descriptors know if they are active low or
> high and can assert the line properly, so we do not need to
> check the flag OF_GPIO_ACTIVE_LOW returned from the old call
> of_get_gpio_flags() anymore.
>
> Also convert to use managed resources and use dev_* message
> printing while we're at it.

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

 > 1 file changed, 19 insertions(+), 33 deletions(-)

This is what I like with these gpiod conversion patches.
