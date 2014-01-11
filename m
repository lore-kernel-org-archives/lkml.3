Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaAKLdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 06:33:50 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47084 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaAKLds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 06:33:48 -0500
Message-ID: <52D12C25.90802@kernel.org>
Date: Sat, 11 Jan 2014 11:33:57 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-iio@vger.kernel.org
CC: Guenter Roeck <linux@roeck-us.net>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: Re: [PATCH] iio:adc:max1363 clear list of missing features
References: <1389387591-5534-1-git-send-email-vivien.didelot@savoirfairelinux.com>
In-Reply-To: <1389387591-5534-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/01/14 20:59, Vivien Didelot wrote:
> Remove "Control of internal reference" from the list of unimplemented
> features, since as of commit a405b00, external reference is supported if
> the device has a regulator and falls back to internal if it doesn't.
>
> While we are modifying the header, let's make it more concise and remove
> a redundant filename.
>
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Applied to the togreg branch of iio.git. Thanks.
> ---
>   drivers/iio/adc/max1363.c | 10 ++--------
>   1 file changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/iio/adc/max1363.c b/drivers/iio/adc/max1363.c
> index e283f2f..1228272 100644
> --- a/drivers/iio/adc/max1363.c
> +++ b/drivers/iio/adc/max1363.c
> @@ -8,17 +8,11 @@
>     * based on linux/drivers/acron/char/pcf8583.c
>     * Copyright (C) 2000 Russell King
>     *
> +  * Driver for max1363 and similar chips.
> +  *
>     * This program is free software; you can redistribute it and/or modify
>     * it under the terms of the GNU General Public License version 2 as
>     * published by the Free Software Foundation.
> -  *
> -  * max1363.c
> -  *
> -  * Partial support for max1363 and similar chips.
> -  *
> -  * Not currently implemented.
> -  *
> -  * - Control of internal reference.
>     */
>
>   #include <linux/interrupt.h>
>
