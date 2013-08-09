Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967866Ab3HINd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:33:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23643 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967839Ab3HINdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:33:23 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-e7-5204efa27825
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>, "'Chris Ball'" <cjb@laptop.org>
Cc: "'Olof Johansson'" <olof@lixom.net>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1373470926-19314-1-git-send-email-dianders@chromium.org>
 <1375825071-20922-1-git-send-email-dianders@chromium.org>
 <1375825071-20922-3-git-send-email-dianders@chromium.org>
In-reply-to: <1375825071-20922-3-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v4 2/4] mmc: dw_mmc: Add exynos resume_noirq callback to
 clear WAKEUP_INT
Date: Fri, 09 Aug 2013 22:33:21 +0900
Message-id: <001901ce9505$04483820$0cd8a860$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6S7lB0/NzKXL4MRHK99mtQSd+wogB/ZZKA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t8zfd1F71mCDKZOFLJ4vGYxk8WDedvY
	LLa/3shmcXbZQTaLV0d+MFm8m/eC2eLGrzZWi94FV9ksNj2+xmpxedccNosj//sZLWac38dk
	cer6ZzaLVbv+MDrwecxuuMjisXPWXXaPnp1nGD0OXVnL6LF5Sb3HlRNNrB59W1YxenzeJBfA
	EcVlk5Kak1mWWqRvl8CVsf5tM2vBNrmK5ye3sjUw3pfoYuTgkBAwkXg7R7iLkRPIFJO4cG89
	WxcjF4eQwDJGiSPLtrNBJEwkpn5fzAiRWMQosanjECtIQkjgD6PEsg16IDabgJbE3zdvmEFs
	EQEviRe7H4DZzAJXmSVadxpANO9llJi89wEjSIJTwE3i6Ol7YIOEBeIlvv57xQJiswioSiy9
	fgQszitgK/Fhxk8mCFtQ4sfkeywQQw0k3s/qY4Ww5SU2r3nLDPGNusSjv7oQNxhJbP61nhGi
	RERi34t3YA9ICOzgkNi86gYTxC4BiW+TD7FA9MpKbDrADPGwpMTBFTdYJjBKzEKyeRaSzbOQ
	bJ6FZMUCRpZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGCHpYcIOxnsHrA8xJgOtn8gsJZqc
	D0wveSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpg
	XHT4bL7MNUv+aW9zGY/ovuYr23HKvYZjnpnCwh9FG4I0rdba8aXfST5yb778g528KztS1xqo
	zb3+VCfo3sWTj/fPXcAU5DHlhrtkpLFHZCzHeq5J205uDLj1diHflGNm3y5leDzPXi67fupD
	3lCNzd+W7zplfdTmq6afzYE9MkfXXnhk9mxxrJoSS3FGoqEWc1FxIgAFwDKRJQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsVy+t9jAd1F71mCDJbv4rF4vGYxk8WDedvY
	LLa/3shmcXbZQTaLV0d+MFm8m/eC2eLGrzZWi94FV9ksNj2+xmpxedccNosj//sZLWac38dk
	cer6ZzaLVbv+MDrwecxuuMjisXPWXXaPnp1nGD0OXVnL6LF5Sb3HlRNNrB59W1YxenzeJBfA
	EdXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLiS
	QlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWP922bWgm1yFc9PbmVrYLwv
	0cXIySEhYCIx9ftiRghbTOLCvfVsXYxcHEICixglNnUcYgVJCAn8YZRYtkEPxGYT0JL4++YN
	M4gtIuAl8WL3AzCbWeAqs0TrTgOI5r2MEpP3PgCbyingJnH09D2wQcIC8RJf/71iAbFZBFQl
	ll4/AhbnFbCV+DDjJxOELSjxY/I9FoihBhLvZ/WxQtjyEpvXvAVaxgF0qbrEo7+6EDcYSWz+
	tZ4RokREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+
	7iZGcPp5JrWDcWWDxSFGAQ5GJR5exe3MQUKsiWXFlbmHGCU4mJVEeLdPYAkS4k1JrKxKLcqP
	LyrNSS0+xJgM9OhEZinR5HxgaswriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6Yklqdmpq
	QWoRzBYmDk6pBsaLK8TTj/z88zWv1fnfsf1OMc9+s8lo74v+/2HJ41DpFu7jH/9wZRZEb/Mu
	/DMjdGn98i8nm4UPb6sovXRaPCr1yWWxl5sC1n32ChHNKU1L45q//6Xg99//LE7fOcURfuSs
	xkH9j4Kyr1YUR5fL3Zxc1pqpnuEq7vXK5fz5H7uu3Zmz9/Dys33mSizFGYmGWsxFxYkAKv+F
	GoMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, August 07, 2013, Doug Anderson wrote:
> If the WAKEUP_INT is asserted at wakeup and not cleared, we'll end up
> looping around forever.  This has been seen to happen on exynos5420
> silicon despite the fact that we haven't enabled any wakeup events due
> to a silicon errata.  It is safe to do on all exynos variants.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v4:
> - Take Seungwon's suggestion and don't add any dw_mmc-pltfm code.
> 
> Changes in v3:
> - Add freeze/thaw and poweroff/restore noirq entries.
> 
> Changes in v2:
> - Use suspend_noirq as per James Hogan.
> 
>  drivers/mmc/host/dw_mmc-exynos.c | 51 ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 49 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
> index 866edef..0c1f192 100644
> --- a/drivers/mmc/host/dw_mmc-exynos.c
> +++ b/drivers/mmc/host/dw_mmc-exynos.c
> @@ -30,6 +30,7 @@
>  #define SDMMC_CLKSEL_TIMING(x, y, z)	(SDMMC_CLKSEL_CCLK_SAMPLE(x) |	\
>  					SDMMC_CLKSEL_CCLK_DRIVE(y) |	\
>  					SDMMC_CLKSEL_CCLK_DIVIDER(z))
> +#define SDMMC_CLKSEL_WAKEUP_INT		BIT(11)
> 
>  #define EXYNOS4210_FIXED_CIU_CLK_DIV	2
>  #define EXYNOS4412_FIXED_CIU_CLK_DIV	4
> @@ -100,6 +101,30 @@ static int dw_mci_exynos_setup_clock(struct dw_mci *host)
>  	return 0;
>  }
> 
> +/**
> + * dw_mci_exynos_resume_noirq - Exynos-specific resume code
> + *
> + * On exynos5420 there is a silicon errata that will sometimes leave the
> + * WAKEUP_INT bit in the CLKSEL register asserted.  This bit is 1 to indicate
> + * that it fired and we can clear it by writing a 1 back.  Clear it to prevent
> + * interrupts from going off constantly.
> + *
> + * We run this code on all exynos variants because it doesn't hurt and the bug
> + * may be more widespread than just exynos5420.
I guess just above comment can be removed. (Not be widespread)
Updating the origin value of CLKSEL looks like no harm while SDMMC_CLKSEL_WAKEUP_INT is cleared.

> + */
> +
> +static int dw_mci_exynos_resume_noirq(struct device *dev)
> +{
> +	struct dw_mci *host = dev_get_drvdata(dev);
> +	u32 clksel;
> +
> +	clksel = mci_readl(host, CLKSEL);
> +	if (clksel & SDMMC_CLKSEL_WAKEUP_INT)
> +		mci_writel(host, CLKSEL, clksel);
> +
> +	return 0;
> +}
> +
>  static void dw_mci_exynos_prepare_command(struct dw_mci *host, u32 *cmdr)
>  {
>  	/*
> @@ -187,17 +212,39 @@ static int dw_mci_exynos_probe(struct platform_device *pdev)
>  	return dw_mci_pltfm_register(pdev, drv_data);
>  }
> 
> +static struct dev_pm_ops dw_mci_exynos_pmops;
> +
>  static struct platform_driver dw_mci_exynos_pltfm_driver = {
>  	.probe		= dw_mci_exynos_probe,
>  	.remove		= __exit_p(dw_mci_pltfm_remove),
>  	.driver		= {
>  		.name		= "dwmmc_exynos",
>  		.of_match_table	= dw_mci_exynos_match,
> -		.pm		= &dw_mci_pltfm_pmops,
> +		.pm		= &dw_mci_exynos_pmops,
>  	},
>  };
> 
> -module_platform_driver(dw_mci_exynos_pltfm_driver);
> +static int __init dw_mci_exynos_init(void)
> +{
> +	/* Add a "noirq" resume to platform pmops */
> +	memcpy(&dw_mci_exynos_pmops, &dw_mci_pltfm_pmops,
> +	       sizeof(dw_mci_exynos_pmops));
> +	WARN_ON(dw_mci_exynos_pmops.resume_noirq ||
> +		dw_mci_exynos_pmops.thaw_noirq ||
> +		dw_mci_exynos_pmops.restore_noirq);
> +	dw_mci_exynos_pmops.resume_noirq = dw_mci_exynos_resume_noirq;
> +	dw_mci_exynos_pmops.thaw_noirq = dw_mci_exynos_resume_noirq;
> +	dw_mci_exynos_pmops.restore_noirq = dw_mci_exynos_resume_noirq;

If CONFIG_PM_SLEEP is not defined, we don't need to add it.
And also, instead of reusing dw_mci_pltfm_pmops, how about defining dw_mci_exynos_pmops's own?
Of course, suspend/resume will not different with dw_mci_pltfm* just now.
But specific code for exynos would be added soon.

Thanks,
Seungwon Jeon

