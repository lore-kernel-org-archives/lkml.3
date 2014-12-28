Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaL1Xdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 18:33:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16217 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaL1Xdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 18:33:46 -0500
X-AuditID: cbfee68e-f79b46d000002b74-fb-54a09357af61
Message-id: <54A09356.5000207@samsung.com>
Date: Mon, 29 Dec 2014 08:33:42 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de,
        olof@lixom.net, catalin.marinas@arm.com, will.deacon@arm.com,
        s.nawrocki@samsung.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/19] pinctrl: exynos: Add support for Exynos5433
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
 <1417073716-22997-2-git-send-email-cw00.choi@samsung.com>
 <549FE7C9.5010909@gmail.com>
In-reply-to: <549FE7C9.5010909@gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWyRsSkUDd88oIQg5aZShaP1yxmsvg76Ri7
	xftlPYwWl/drW8w/co7V4s+EVjaLSfcnsFjc+NXGatG74CqbxdmmN+wWU/4sZ7LY9Pgaq8Xl
	XXPYLGac38dksfT6RSaLU9c/s1kcftPOajFj8ks2i2MzljBarNr1h9Hi5ccTLA6iHmvmrWH0
	+P1rEqPHzll32T3uXNvD5rF5Sb3HlRNNrB59W1YxenzeJBfAEcVlk5Kak1mWWqRvl8CV8aT7
	OHPBeY2KrRuWMjYwrlPsYuTkkBAwkfj8t4cZwhaTuHBvPVsXIxeHkMBSRok3d9qZYYoWt/5h
	hUgsYpTovbwWquo1o8S5xmdMIFW8AloSP579ArNZBFQluv4fZgex2YDi+1/cYAOxRQXCJFZO
	v8ICUS8o8WPyPTBbREBd4tuUfnaQocwCbSwSe17cZARJCAu4SWzafp8FYtsCRolTCxeDbeAU
	0JS48+I1kM0B1KEncf+iFkiYWUBeYvOat8wg9RICZzgk7s5ZyAZxkYDEt8mHWEDqJQRkJTYd
	gHpNUuLgihssExjFZiG5aRbC1FlIpi5gZF7FKJpakFxQnJReZKRXnJhbXJqXrpecn7uJEZge
	Tv971reD8eYB60OMAhyMSjy8E47NDxFiTSwrrsw9xGgKdMREZinR5HxgEsoriTc0NjOyMDUx
	NTYytzRTEudNkPoZLCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHRoultqMiGy+uLZ+s9vatc
	vMzEbdKbNOtppt8K10bPuLBB7PCuH4/bWTQ3RsfacXhlm4vNWvwoVVHGNNlSuNqgwVnqtovB
	5vPX7oStTv3BYa/saO3nypE09+GykB3l1737vTPDb8yM25Y54ZrCrmcJtR47BX9oZ8u+VU2L
	3dE7X6pCesFB/lAlluKMREMt5qLiRAA71h4mCgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jAd3wyQtCDE70iFs8XrOYyeLvpGPs
	Fu+X9TBaXN6vbTH/yDlWiz8TWtksJt2fwGJx41cbq0XvgqtsFmeb3rBbTPmznMli0+NrrBaX
	d81hs5hxfh+TxdLrF5ksTl3/zGZx+E07q8WMyS/ZLI7NWMJosWrXH0aLlx9PsDiIeqyZt4bR
	4/evSYweO2fdZfe4c20Pm8fmJfUeV040sXr0bVnF6PF5k1wAR1QDo01GamJKapFCal5yfkpm
	XrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0GtKCmWJOaVAoYDE4mIlfTtME0JD
	3HQtYBojdH1DguB6jAzQQMIaxown3ceZC85rVGzdsJSxgXGdYhcjJ4eEgInE4tY/rBC2mMSF
	e+vZuhi5OIQEFjFK9F5eC+W8ZpQ41/iMCaSKV0BL4sezX2A2i4CqRNf/w+wgNhtQfP+LG2wg
	tqhAmMTK6VdYIOoFJX5MvgdmiwioS3yb0s8OMpRZoI1FYs+Lm4wgCWEBN4lN2++zQGxbwChx
	auFisA2cApoSd168BrI5gDr0JO5f1AIJMwvIS2xe85Z5AqPALCQ7ZiFUzUJStYCReRWjaGpB
	ckFxUnquoV5xYm5xaV66XnJ+7iZGcPJ5JrWDcWWDxSFGAQ5GJR7eCcfmhwixJpYVV+YeYpTg
	YFYS4TUqWxAixJuSWFmVWpQfX1Sak1p8iNEUGAITmaVEk/OBiTGvJN7Q2MTMyNLI3NDCyNhc
	SZxXyb4tREggPbEkNTs1tSC1CKaPiYNTqoFx+pmNd10WMR4/yqkyPfvgBT8lw5/Oj+xjp1/W
	2B9zr+TTu+9R24TzY2dOu7Z89QJGe7aJqVX9ypKVdjWR0Vfv8MfP1Zux+sJ29e1rzP0KZ/9t
	3vz097f3SobqCs8ec31ICFK8U12b7czgunF1o+XFl5dmL5O7FFHxOPXlgjxDLTZWLYMfZuW6
	SizFGYmGWsxFxYkA8i+8+1QDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 12/28/2014 08:21 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 27.11.2014 16:34, Chanwoo Choi wrote:
>> This patch adds driver data for Exynos5433 SoC. Exynos5433 includes 228 multi-
>> functional input/output port pins and 135 memory port pins. There are 41 general
>> port groups and 2 memory port groups.
>>
>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>> Cc: Thomas Abraham <thomas.abraham@linaro.org>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
>> Acked-by: Inki Dae <inki.dae@samsung.com>
>> ---
>>   drivers/pinctrl/samsung/pinctrl-exynos.c  | 163 ++++++++++++++++++++++++++++++
>>   drivers/pinctrl/samsung/pinctrl-samsung.c |   2 +
>>   drivers/pinctrl/samsung/pinctrl-samsung.h |   1 +
>>   3 files changed, 166 insertions(+)
> 
> Any plans for a respin? Apparently this patch needs a rebase. Also some comments below.

I'll rebase it on latest kernel and re-send it on next time.

> 
>>
>> diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
>> index 8e3e0c0..bd4c4ec 100644
>> --- a/drivers/pinctrl/samsung/pinctrl-exynos.c
>> +++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
>> @@ -1268,6 +1268,169 @@ struct samsung_pin_ctrl exynos5420_pin_ctrl[] = {
>>       },
>>   };
>>
>> +/* pin banks of exynos5433 pin-controller - ALIVE */
>> +static struct samsung_pin_bank exynos5433_pin_banks0[] = {
> 
> Maybe instead the structure could be named exynos5433_pin_bank_alive? Similarly for remaining banks.
> 
> Also please, if not done already, please remember about documenting alias IDs of particular controllers in DT binding documentation.
> 
>> +    EXYNOS_PIN_BANK_EINTW(8, 0x000, "gpa0", 0x00),
>> +    EXYNOS_PIN_BANK_EINTW(8, 0x020, "gpa1", 0x04),
>> +    EXYNOS_PIN_BANK_EINTW(8, 0x040, "gpa2", 0x08),
>> +    EXYNOS_PIN_BANK_EINTW(8, 0x060, "gpa3", 0x0c),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - AUD */
>> +static struct samsung_pin_bank exynos5433_pin_banks1[] = {
>> +    EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpz0", 0x00),
>> +    EXYNOS_PIN_BANK_EINTG(4, 0x020, "gpz1", 0x04),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - CPIF */
>> +static struct samsung_pin_bank exynos5433_pin_banks2[] = {
>> +    EXYNOS_PIN_BANK_EINTG(2, 0x000, "gpv6", 0x00),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - eSE */
>> +static struct samsung_pin_bank exynos5433_pin_banks3[] = {
>> +    EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj2", 0x00),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - FINGER */
>> +static struct samsung_pin_bank exynos5433_pin_banks4[] = {
>> +    EXYNOS_PIN_BANK_EINTG(4, 0x000, "gpd5", 0x00),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - FSYS */
>> +static struct samsung_pin_bank exynos5433_pin_banks5[] = {
>> +    EXYNOS_PIN_BANK_EINTG(6, 0x000, "gph1", 0x00),
>> +    EXYNOS_PIN_BANK_EINTG(7, 0x020, "gpr4", 0x04),
>> +    EXYNOS_PIN_BANK_EINTG(5, 0x040, "gpr0", 0x08),
>> +    EXYNOS_PIN_BANK_EINTG(8, 0x060, "gpr1", 0x0c),
>> +    EXYNOS_PIN_BANK_EINTG(2, 0x080, "gpr2", 0x10),
>> +    EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpr3", 0x14),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - IMEM */
>> +static struct samsung_pin_bank exynos5433_pin_banks6[] = {
>> +    EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpf0", 0x00),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - NFC */
>> +static struct samsung_pin_bank exynos5433_pin_banks7[] = {
>> +    EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj0", 0x00),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - PERIC */
>> +static struct samsung_pin_bank exynos5433_pin_banks8[] = {
>> +    EXYNOS_PIN_BANK_EINTG(6, 0x000, "gpv7", 0x00),
>> +    EXYNOS_PIN_BANK_EINTG(5, 0x020, "gpb0", 0x04),
>> +    EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpc0", 0x08),
>> +    EXYNOS_PIN_BANK_EINTG(2, 0x060, "gpc1", 0x0c),
>> +    EXYNOS_PIN_BANK_EINTG(6, 0x080, "gpc2", 0x10),
>> +    EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpc3", 0x14),
>> +    EXYNOS_PIN_BANK_EINTG(2, 0x0c0, "gpg0", 0x18),
>> +    EXYNOS_PIN_BANK_EINTG(4, 0x0e0, "gpd0", 0x1c),
>> +    EXYNOS_PIN_BANK_EINTG(6, 0x100, "gpd1", 0x20),
>> +    EXYNOS_PIN_BANK_EINTG(8, 0x120, "gpd2", 0x24),
>> +    EXYNOS_PIN_BANK_EINTG(5, 0x140, "gpd4", 0x28),
>> +    EXYNOS_PIN_BANK_EINTG(2, 0x160, "gpd8", 0x2c),
>> +    EXYNOS_PIN_BANK_EINTG(7, 0x180, "gpd6", 0x30),
>> +    EXYNOS_PIN_BANK_EINTG(3, 0x1a0, "gpd7", 0x34),
>> +    EXYNOS_PIN_BANK_EINTG(5, 0x1c0, "gpg1", 0x38),
>> +    EXYNOS_PIN_BANK_EINTG(2, 0x1e0, "gpg2", 0x3c),
>> +    EXYNOS_PIN_BANK_EINTG(8, 0x200, "gpg3", 0x40),
>> +};
>> +
>> +/* pin banks of exynos5433 pin-controller - TOUCH */
>> +static struct samsung_pin_bank exynos5433_pin_banks9[] = {
>> +    EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj1", 0x00),
>> +};
>> +
>> +/*
>> + * Samsung pinctrl driver data for Exynos5433 SoC. Exynos5433 SoC includes
>> + * four gpio/pin-mux/pinconfig controllers.
> 
> Looks like "four" is a copy/paste error here.

Mistake. I'll fix it.

Best Regards,
Chanwoo Choi
