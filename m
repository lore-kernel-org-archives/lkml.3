Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaK0K0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:26:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:59877 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaK0K0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:26:22 -0500
X-AuditID: cbfee68e-f79b46d000002b74-ce-5476fc4b062d
Message-id: <5476FC4E.7030505@samsung.com>
Date: Thu, 27 Nov 2014 15:56:22 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, s.nawrocki@samsung.com,
        tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [01/19] pinctrl: exynos: Add support for Exynos5433
References: <1417073716-22997-2-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1417073716-22997-2-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec85OztK1mleehtYMeiLos77a2n5xZhIF0gkuumy4wWvbLrq
	SzpjTVeJzsQxpi7avKxhMJVUzHSaaFIZmpfwBmppLlRmVmtKbuuD3348lx//Bx4K59gILpWZ
	W8CIcoXZPNKdMHqF3Q9IsEsS+fKRk2jR+BxDO8pBNlpveAzQ2Bt/NLn1jYXqBz6wkL1CRiLl
	fAWBpmwPWeiJ9jOJ3pdY2OipvRFDpsUJFhrr0pBI9bEHQ/rJTxh6N2klUb9FzkKqqlUSDap0
	ABm67ACtbg4RsT4CY50RCP7alEDQqZ5lC2YmuklBq65IMD5UwhKUtxmAwGo6dom66h59m8nO
	lDCioDMp7hly1QiWXxp/d/CXnF0MNqIVwI2CdBg0KQ2Yi33g6NxL0sEcWg/gsCpTASjnjN16
	1lWuAVBTmqAA7nssw6Buo47laHjQfrBZN+xkgj4Jv5vbgYNJOgAurdfiDvamr8Bxowa45g/D
	31VzhIO96Cy4bOknHVKc/oLD+g6rc8GTjoVL0tf/A8VBy6t2Z1A3+hycfSR3inA6BmrXWwgX
	H4etxh+4QwTpUQp2NpdhrkQ03K4yE65rfKGpF3cdfBT2NU0RFcBHvS+Tep9WvU+rBbgBeDP5
	qfniW+mikECxMEdcmJsemJqXYwJ7LzGy+7W8A0z3njYDmgK8Ax6oV5LIYQkl4ns5ZhC+l6IS
	53qn5u19UW5BcnBoRAgKDwsPDYmMiuAd8Ujh/rnModOFBUwWw+QzomRRYTYjNgOMcuMWAyCr
	kd5UNLQnBa0d7JmP0AdMN+ys7HSmxDcVFcwdGjCQN95eLzz/rMv3FDuqsGcleSriAt9qbkuf
	bEmwVIbGVCz/PAHSFH3VC7uN1dsPmss888KuzUDpxkL7miXOXz9v2+zmNC/I7tRSGi4h8Sjl
	+5VrGe0LvjQyKS35ItziEeIMYbAfLhIL/wFPu/13DQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jQV3vP2UhBhdeSlo8XrOYyeLvpGPs
	Fu+X9TBaXN6vbXH9y3NWi/lHzrFa/JnQymYx6f4EFosbv9pYLXoXXGWzONv0ht1iyp/lTBab
	Hl9jtbi8aw6bxYzz+5gsll6/yGRx6vpnNovDb9pZLWZMfslmcWzGEkaLVbv+MFq8/HiCxUHM
	Y828NYwev39NYvTYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5AI4ohoYbTJSE1NSixRS
	85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA/lNSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYwZrTPOM1U0OFZcex7O3sD4webLkYODgkBE4k/n+27
	GDmBTDGJC/fWs4HYQgLTGSXmdHh3MXIB2a1MEks+zGMFSfAKaEmsXHISzGYRUJV4dWgrI4jN
	JqAr8eT9XGYQW1QgQuLKmjmMEPWCEj8m32MBsUUEsiWevjnMBjKUWeAWs8T8HZ/BGoQFHCSe
	NO6F2uwq8Wb7ViYQm1PATeJudzvYIGYBW4kF79exQNjyEpvXvGWewCgwC8mOWUjKZiEpW8DI
	vIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOAk9k9rBuLLB4hCjAAejEg+vxYGyECHWxLLi
	ytxDjBIczEoivFKLgEK8KYmVValF+fFFpTmpxYcYTYFBMJFZSjQ5H5gg80riDY1NzE2NTS1N
	LEzMLJXEeW/czA0REkhPLEnNTk0tSC2C6WPi4JRqYPQ+vnC+m87pteKtHZyPLjndZnNw/Ptl
	VkTD3tKGfSdLu3YlaD87V2yvVey1prUtLNDdLDP9j3dxtImKk78w7x/jY8yvt11ePSem9bXl
	tMu1LMsjRBO8ZnPqml5YejY4TPP2qfOlRzIU1bzCTFS+60sk1JpV3LEsLj6zdkPA0p9KPwPt
	uO4sV2Ipzkg01GIuKk4EADSVJTFYAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Thursday 27 November 2014 01:04 PM, Chanwoo Choi wrote:
> This patch adds driver data for Exynos5433 SoC. Exynos5433 includes 228 multi-
> functional input/output port pins and 135 memory port pins. There are 41 general
> port groups and 2 memory port groups.
>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
>
> ---
> drivers/pinctrl/samsung/pinctrl-exynos.c  | 163 ++++++++++++++++++++++++++++++
>   drivers/pinctrl/samsung/pinctrl-samsung.c |   2 +
>   drivers/pinctrl/samsung/pinctrl-samsung.h |   1 +
>   3 files changed, 166 insertions(+)
>
> diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
> index 8e3e0c0..bd4c4ec 100644
> --- a/drivers/pinctrl/samsung/pinctrl-exynos.c
> +++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
> @@ -1268,6 +1268,169 @@ struct samsung_pin_ctrl exynos5420_pin_ctrl[] = {
>   	},
>   };
>
> +/* pin banks of exynos5433 pin-controller - ALIVE */
> +static struct samsung_pin_bank exynos5433_pin_banks0[] = {
> +	EXYNOS_PIN_BANK_EINTW(8, 0x000, "gpa0", 0x00),
> +	EXYNOS_PIN_BANK_EINTW(8, 0x020, "gpa1", 0x04),
> +	EXYNOS_PIN_BANK_EINTW(8, 0x040, "gpa2", 0x08),
> +	EXYNOS_PIN_BANK_EINTW(8, 0x060, "gpa3", 0x0c),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - AUD */
> +static struct samsung_pin_bank exynos5433_pin_banks1[] = {
> +	EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpz0", 0x00),
> +	EXYNOS_PIN_BANK_EINTG(4, 0x020, "gpz1", 0x04),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - CPIF */
> +static struct samsung_pin_bank exynos5433_pin_banks2[] = {
> +	EXYNOS_PIN_BANK_EINTG(2, 0x000, "gpv6", 0x00),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - eSE */
> +static struct samsung_pin_bank exynos5433_pin_banks3[] = {
> +	EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj2", 0x00),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - FINGER */
> +static struct samsung_pin_bank exynos5433_pin_banks4[] = {
> +	EXYNOS_PIN_BANK_EINTG(4, 0x000, "gpd5", 0x00),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - FSYS */
> +static struct samsung_pin_bank exynos5433_pin_banks5[] = {
> +	EXYNOS_PIN_BANK_EINTG(6, 0x000, "gph1", 0x00),
> +	EXYNOS_PIN_BANK_EINTG(7, 0x020, "gpr4", 0x04),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x040, "gpr0", 0x08),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x060, "gpr1", 0x0c),
> +	EXYNOS_PIN_BANK_EINTG(2, 0x080, "gpr2", 0x10),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpr3", 0x14),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - IMEM */
> +static struct samsung_pin_bank exynos5433_pin_banks6[] = {
> +	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpf0", 0x00),

Is this complete?

> +};
> +
> +/* pin banks of exynos5433 pin-controller - NFC */
> +static struct samsung_pin_bank exynos5433_pin_banks7[] = {
> +	EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj0", 0x00),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - PERIC */
> +static struct samsung_pin_bank exynos5433_pin_banks8[] = {
> +	EXYNOS_PIN_BANK_EINTG(6, 0x000, "gpv7", 0x00),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x020, "gpb0", 0x04),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpc0", 0x08),
> +	EXYNOS_PIN_BANK_EINTG(2, 0x060, "gpc1", 0x0c),
> +	EXYNOS_PIN_BANK_EINTG(6, 0x080, "gpc2", 0x10),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpc3", 0x14),
> +	EXYNOS_PIN_BANK_EINTG(2, 0x0c0, "gpg0", 0x18),
> +	EXYNOS_PIN_BANK_EINTG(4, 0x0e0, "gpd0", 0x1c),
> +	EXYNOS_PIN_BANK_EINTG(6, 0x100, "gpd1", 0x20),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x120, "gpd2", 0x24),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x140, "gpd4", 0x28),
> +	EXYNOS_PIN_BANK_EINTG(2, 0x160, "gpd8", 0x2c),
> +	EXYNOS_PIN_BANK_EINTG(7, 0x180, "gpd6", 0x30),
> +	EXYNOS_PIN_BANK_EINTG(3, 0x1a0, "gpd7", 0x34),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x1c0, "gpg1", 0x38),
> +	EXYNOS_PIN_BANK_EINTG(2, 0x1e0, "gpg2", 0x3c),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x200, "gpg3", 0x40),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - TOUCH */
> +static struct samsung_pin_bank exynos5433_pin_banks9[] = {
> +	EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj1", 0x00),
> +};
> +
> +/*
> + * Samsung pinctrl driver data for Exynos5433 SoC. Exynos5433 SoC includes
> + * four gpio/pin-mux/pinconfig controllers.

four? I can see you added 10.


Thanks,
Pankaj Dubey
> + */
> +struct samsung_pin_ctrl exynos5433_pin_ctrl[] = {
> +	{
> +		/* pin-controller instance 0 data */
> +		.pin_banks	= exynos5433_pin_banks0,
> +		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks0),
> +		.eint_wkup_init = exynos_eint_wkup_init,
> +		.suspend	= exynos_pinctrl_suspend,
> +		.resume		= exynos_pinctrl_resume,
> +		.label		= "exynos5433-gpio-ctrl0",
> +	}, {
> +		/* pin-controller instance 1 data */
> +		.pin_banks	= exynos5433_pin_banks1,
> +		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks1),
> +		.eint_gpio_init = exynos_eint_gpio_init,
> +		.suspend	= exynos_pinctrl_suspend,
> +		.resume		= exynos_pinctrl_resume,
> +		.label		= "exynos5433-gpio-ctrl1",
> +	}, {
> +		/* pin-controller instance 2 data */
> +		.pin_banks	= exynos5433_pin_banks2,
> +		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks2),
> +		.eint_gpio_init = exynos_eint_gpio_init,
> +		.suspend	= exynos_pinctrl_suspend,
> +		.resume		= exynos_pinctrl_resume,
> +		.label		= "exynos5433-gpio-ctrl2",
> +	}, {
> +		/* pin-controller instance 3 data */
> +		.pin_banks	= exynos5433_pin_banks3,
> +		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks3),
> +		.eint_gpio_init = exynos_eint_gpio_init,
> +		.suspend	= exynos_pinctrl_suspend,
> +		.resume		= exynos_pinctrl_resume,
> +		.label		= "exynos5433-gpio-ctrl3",
> +	}, {
> +		/* pin-controller instance 4 data */
> +		.pin_banks	= exynos5433_pin_banks4,
> +		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks4),
> +		.eint_gpio_init = exynos_eint_gpio_init,
> +		.suspend	= exynos_pinctrl_suspend,
> +		.resume		= exynos_pinctrl_resume,
> +		.label		= "exynos5433-gpio-ctrl4",
> +	}, {
> +		/* pin-controller instance 5 data */
> +		.pin_banks	= exynos5433_pin_banks5,
> +		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks5),
> +		.eint_gpio_init = exynos_eint_gpio_init,
> +		.suspend	= exynos_pinctrl_suspend,
> +		.resume		= exynos_pinctrl_resume,
> +		.label		= "exynos5433-gpio-ctrl5",
> +	}, {
> +		/* pin-controller instance 6 data */
> +		.pin_banks	= exynos5433_pin_banks6,
> +		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks6),
> +		.eint_gpio_init = exynos_eint_gpio_init,
> +		.suspend	= exynos_pinctrl_suspend,
> +		.resume		= exynos_pinctrl_resume,
> +		.label		= "exynos5433-gpio-ctrl6",
> +	}, {
> +		/* pin-controller instance 7 data */
> +		.pin_banks	= exynos5433_pin_banks7,
> +		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks7),
> +		.eint_gpio_init = exynos_eint_gpio_init,
> +		.suspend	= exynos_pinctrl_suspend,
> +		.resume		= exynos_pinctrl_resume,
> +		.label		= "exynos5433-gpio-ctrl7",
> +	}, {
> +		/* pin-controller instance 8 data */
> +		.pin_banks	= exynos5433_pin_banks8,
> +		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks8),
> +		.eint_gpio_init = exynos_eint_gpio_init,
> +		.suspend	= exynos_pinctrl_suspend,
> +		.resume		= exynos_pinctrl_resume,
> +		.label		= "exynos5433-gpio-ctrl8",
> +	}, {
> +		/* pin-controller instance 9 data */
> +		.pin_banks	= exynos5433_pin_banks9,
> +		.nr_banks	= ARRAY_SIZE(exynos5433_pin_banks9),
> +		.eint_gpio_init = exynos_eint_gpio_init,
> +		.suspend	= exynos_pinctrl_suspend,
> +		.resume		= exynos_pinctrl_resume,
> +		.label		= "exynos5433-gpio-ctrl9",
> +	},
> +};
> +
>   /* pin banks of exynos7 pin-controller - ALIVE */
>   static struct samsung_pin_bank exynos7_pin_banks0[] = {
>   	EXYNOS_PIN_BANK_EINTW(8, 0x000, "gpa0", 0x00),
> diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
> index e0ba851..4eb61ea 100644
> --- a/drivers/pinctrl/samsung/pinctrl-samsung.c
> +++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
> @@ -1226,6 +1226,8 @@ static const struct of_device_id samsung_pinctrl_dt_match[] = {
>   		.data = (void *)exynos5260_pin_ctrl },
>   	{ .compatible = "samsung,exynos5420-pinctrl",
>   		.data = (void *)exynos5420_pin_ctrl },
> +	{ .compatible = "samsung,exynos5433-pinctrl",
> +		.data = (void *)exynos5433_pin_ctrl },
>   	{ .compatible = "samsung,s5pv210-pinctrl",
>   		.data = (void *)s5pv210_pin_ctrl },
>   	{ .compatible = "samsung,exynos7-pinctrl",
> diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.h b/drivers/pinctrl/samsung/pinctrl-samsung.h
> index e737d1f..d260356 100644
> --- a/drivers/pinctrl/samsung/pinctrl-samsung.h
> +++ b/drivers/pinctrl/samsung/pinctrl-samsung.h
> @@ -245,6 +245,7 @@ extern struct samsung_pin_ctrl exynos4415_pin_ctrl[];
>   extern struct samsung_pin_ctrl exynos5250_pin_ctrl[];
>   extern struct samsung_pin_ctrl exynos5260_pin_ctrl[];
>   extern struct samsung_pin_ctrl exynos5420_pin_ctrl[];
> +extern struct samsung_pin_ctrl exynos5433_pin_ctrl[];
>   extern const struct samsung_pin_ctrl exynos7_pin_ctrl[];
>   extern struct samsung_pin_ctrl s3c64xx_pin_ctrl[];
>   extern struct samsung_pin_ctrl s3c2412_pin_ctrl[];
>
