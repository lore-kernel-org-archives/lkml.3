Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaAIE2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 23:28:06 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36305 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaAIE2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 23:28:02 -0500
MIME-Version: 1.0
In-Reply-To: <1713694.HL69UGM8yf@flatron>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
 <1389095509-14357-5-git-send-email-ch.naveen@samsung.com> <1713694.HL69UGM8yf@flatron>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 9 Jan 2014 09:57:41 +0530
Message-ID: <CAHfPSqDpFHYc+kJ4ghBJYgCSPhaDL1=vrdafJPnmXKNh1etBvw@mail.gmail.com>
Subject: Re: [PATCH 4/5] crypto:s5p-sss: Exynos5 SoCs too can select SSS driver
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Naveen Krishna Ch <ch.naveen@samsung.com>, linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, herbert@gondor.apana.org.au,
        cpgs@samsung.com, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tomasz,

On 8 January 2014 06:00, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On Tuesday 07 of January 2014 17:21:48 Naveen Krishna Ch wrote:
>> This patch modifies Kconfig such that ARCH_EXYNOS5 SoCs
>> can also select Samsung SSS(Security SubSystem) driver.
>>
>> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
>> CC: Herbert Xu <herbert@gondor.apana.org.au>
>> CC: David S. Miller <davem@davemloft.net>
>> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
>> TO: <linux-crypto@vger.kernel.org>
>> CC: <linux-samsung-soc@vger.kernel.org>
>> ---
>>  drivers/crypto/Kconfig |    8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
>> index f4fd837..137dcd8 100644
>> --- a/drivers/crypto/Kconfig
>> +++ b/drivers/crypto/Kconfig
>> @@ -300,15 +300,15 @@ config CRYPTO_DEV_DCP
>>         capabilities of the DCP co-processor
>>
>>  config CRYPTO_DEV_S5P
>> -     tristate "Support for Samsung S5PV210 crypto accelerator"
>> -     depends on ARCH_S5PV210
>> +     tristate "Support for Samsung crypto accelerator"
>> +     depends on ARCH_S5PV210 || ARCH_EXYNOS5
>>       select CRYPTO_AES
>>       select CRYPTO_ALGAPI
>>       select CRYPTO_BLKCIPHER
>>       help
>>         This option allows you to have support for S5P crypto acceleration.
>> -       Select this to offload Samsung S5PV210 or S5PC110 from AES
>> -       algorithms execution.
>> +       Select this to offload Samsung S5PV210 or S5PC110, Exynos5250
>> +       and Exynos5420 from AES algorithms execution.
>
> What about Exynos4 SoCs?
The SSS module as such looks alike on Exynos5250, Exynso5420 and Exynos4210.
I couldn't test it right now. I should also verify on other Exynos4 SoCs.
>
> Best regards,
> Tomasz
>



-- 
Shine bright,
(: Nav :)
