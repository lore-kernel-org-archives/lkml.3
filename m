Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3LZIY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 03:24:58 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:64950 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3LZIY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 03:24:56 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-57-52bbe7d61256
From: Jingoo Han <jg1.han@samsung.com>
To: "'Josh Triplett'" <josh@joshtriplett.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Brian Norris'" <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Dinh Nguyen'" <dinguyen@altera.com>
References: <cover.1387833347.git.josh@joshtriplett.org>
 <21175198efaf34a67e5108c1dae384656012b7a0.1387833347.git.josh@joshtriplett.org>
In-reply-to: <21175198efaf34a67e5108c1dae384656012b7a0.1387833347.git.josh@joshtriplett.org>
Subject: Re: [PATCH 1/7] mtd: denali: Drop print of build date/time
Date: Thu, 26 Dec 2013 17:24:53 +0900
Message-id: <000801cf0213$f40bec50$dc23c4f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8AKaKtAl12aAYmSaWB5csvG+VScwB6fg7w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zY91rz3cHGVw7L2tx5MJaZovjlxYz
	W0xcOZnZ4vLCS6wW/xfkW1zeNYfNYnfTMnYHdo/WvRPYPHbOusvusXmFlset17Yem5fUe/Rt
	WcXo8XmTXAB7FJdNSmpOZllqkb5dAlfGyl9rmAp+s1cs/t/A1sB4mK2LkZNDQsBEYn7XeWYI
	W0ziwr31QHEuDiGBZYwSG29uYYUpWtnXzwqRWMQosXTbDmYI5xejRMv/NywgVWwCahJfvhxm
	B7FFBLQldn2eCTaKWeApo0T7vetQc7sYJT4cnwK2nFMgTuLr7Cdgy4UFnCUmr5/I1MXIwcEi
	oCqxbnU5SJhXwFbize8fTBC2oMSPyffAljELaEms33mcCcKWl9i85i0zSKuEgLrEo7+6EDcY
	Sby/sROqRERi34t3jCAnSAh8ZZe4f2wVI0iCRUBA4tvkQywQvbISmw5Ag0JS4uCKGywTGCVm
	Idk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MkGieuIPx/gHrQ4zJ
	QOsnMkuJJucDk0FeSbyhsZmRhamJqbGRuaUZacJK4rzpj5KChATSE0tSs1NTC1KL4otKc1KL
	DzEycXBKNTA2CCswX3bpcTolN6WgZuKpHsX1n6NuhTLdZdXzupt27iRffbnK1efr5zKvU7r+
	aM7USOWPz+87xh37cepF+abyD7pLKx6e+9d35cjr7YFu67O+/bVMDpr/dyKP2I6m31Erzebf
	r6kX4k+cx56+mlm4wEvmv8c1tX086cetfvK19GU7HZaeNH2/EktxRqKhFnNRcSIAU2oiEPwC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t9jAd1rz3cHGVxplLQ4cmEts8XxS4uZ
	LSaunMxscXnhJVaL/wvyLS7vmsNmsbtpGbsDu0fr3glsHjtn3WX32LxCy+PWa1uPzUvqPfq2
	rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUn
	QNctMwfoGiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxspfa5gKfrNX
	LP7fwNbAeJiti5GTQ0LARGJlXz8rhC0mceHeeqA4F4eQwCJGiaXbdjBDOL8YJVr+v2EBqWIT
	UJP48uUwO4gtIqAtsevzTLAOZoGnjBLt965DtXcxSnw4PgVsB6dAnMTX2U+YQWxhAWeJyesn
	MnUxcnCwCKhKrFtdDhLmFbCVePP7BxOELSjxY/I9sGXMAloS63ceZ4Kw5SU2r3nLDNIqIaAu
	8eivLsQNRhLvb+yEKhGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFec
	mFtcmpeul5yfu4kRnCqeSe9gXNVgcYhRgINRiYe3Q3d3kBBrYllxZe4hRgkOZiUR3l3dQCHe
	lMTKqtSi/Pii0pzU4kOMyUB/TmSWEk3OB6axvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJ
	pCeWpGanphakFsFsYeLglGpgbDq1LSvtq/DtoO0Lr3h1aft+ns7DKM2dfWFt4qUYRSvrvcu+
	u/GKbo6y5pbOm1R87/5u/4/z+2ZcnNIt3/Hx+WZF2dcLtk2KvpCp9uftkgdfQqIaj+z3SzrA
	q+met3K65P6tuj99X59RCt87w/kyo7nwzgKPw/OMZd0srSfmpSpGft0o2HRmkxJLcUaioRZz
	UXEiAKYyHYNZAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 24, 2013 6:55 AM, Josh Triplett wrote:
> 
> The kernel already has this information, and individual drivers
> shouldn't duplicate that.  This also eliminates the use of __DATE__ and
> __TIME__, which make the build non-deterministic.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

(+cc Dinh Nguyen)

It looks good. :-)
Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/mtd/nand/denali_pci.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/denali_pci.c b/drivers/mtd/nand/denali_pci.c
> index 033f177..ab64416 100644
> --- a/drivers/mtd/nand/denali_pci.c
> +++ b/drivers/mtd/nand/denali_pci.c
> @@ -131,7 +131,6 @@ static struct pci_driver denali_pci_driver = {
> 
>  static int denali_init_pci(void)
>  {
> -	pr_info("Spectra MTD driver built on %s @ %s\n", __DATE__, __TIME__);
>  	return pci_register_driver(&denali_pci_driver);
>  }
>  module_init(denali_init_pci);
> --
> 1.8.5.2

