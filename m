Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaGMSnC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 14:43:02 -0400
Received: from mail.kernel.org ([198.145.19.201]:60781 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbaGMSm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 14:42:56 -0400
Message-ID: <53C2D3B4.4040509@kernel.org>
Date: Sun, 13 Jul 2014 19:45:08 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>, Chen Gang <gang.chen.5i5j@gmail.com>
CC: Richard Weinberger <richard@nod.at>, Liqin Chen <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lars@metafoo.de,
        knaack.h@gmx.de, rdunlap@infradead.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/staging/iio/adc/Kconfig: Let MXS_LRADC depend
 on HAS_IOMEM
References: <53C27126.50208@gmail.com> <201407131527.38792.marex@denx.de>
In-Reply-To: <201407131527.38792.marex@denx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/07/14 14:27, Marek Vasut wrote:
> On Sunday, July 13, 2014 at 01:44:38 PM, Chen Gang wrote:
>> MXS_LRADC need HAS_IOMEM, so let it depend on HAS_IOMEM
>>
>> The related error (with allmodconfig under score):
>>
>>      MODPOST 1365 modules
>>    ERROR: "devm_ioremap_resource" [drivers/staging/iio/adc/mxs-lradc.ko]
>> undefined!
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>
> Acked-by: Marek Vasut <marex@denx.de>
Applied to the togreg branch of iio.git.

Thanks,
>
> Best regards,
> Marek Vasut
>

