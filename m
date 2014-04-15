Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaDOGhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 02:37:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30840 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaDOGhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 02:37:31 -0400
X-AuditID: cbfee690-b7f266d00000287c-6a-534cd3a990cc
Message-id: <534CD3AC.5070801@samsung.com>
Date: Tue, 15 Apr 2014 15:37:32 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v5 6/9] mfd: max14577: Add MAX14577 prefix to IRQ defines
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
 <1397467040-30502-7-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1397467040-30502-7-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsWyRsSkSHflZZ9gg1tnNCw2zljPajH14RM2
	i9cvDC3ONr1ht7j/9SijxbcrHUwWl3fNYbNYe+Quu8XtxhVsFqe7WR24PHbOusvusWlVJ5vH
	nWt72DzmnQz06NuyitHj8ya5ALYoLpuU1JzMstQifbsErowdc/ayFEyVr1jz4S1rA+MRyS5G
	Tg4JAROJVfceMkPYYhIX7q1n62Lk4hASWMooMW3LV1aYohe3PzFBJKYzSjy/d4wFwnnNKDGr
	+TYTSBWvgJbEooY7YDaLgKrE2isL2EFsNqD4/hc32EBsUYEwiZXTr7BA1AtK/Jh8D8wWETCU
	OLh7O9gGZoH3TBJbZ88EGyQs4Ctxfv0UZohtrYwSC89/BDuWU8BD4vqCg2BTmQV0JPa3ToOy
	5SU2r3kL1iAh8JJd4tH9q1AnCUh8m3wIaB0HUEJWYtMBqKclJQ6uuMEygVFsFpKjZiEZOwvJ
	2AWMzKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxAuPz9L9nE3Yw3jtgfYgxGWjlRGYp0eR8
	YHznlcQbGpsZWZiamBobmVuakSasJM6r9igpSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPj
	lNUnGuc35d4x8n6xOcqvq/MYA99pRolTkg+4PpS/COXpXfrzZ3OoePgSjx1yT+sztFId759a
	7f3773Gxz8Z8Wx0Tp5yWef3MbYLBNscNp664Mtw3iZ/NbbNjh8bMFkap/yZv8yZ8nWvQdCLB
	P2W64xWhA9k7H4pesrj2ZNaGnm7DI/o7FBMfKbEUZyQaajEXFScCALD6fkDlAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQd2Vl32CDTa+krPYOGM9q8XUh0/Y
	LF6/MLQ42/SG3eL+16OMFt+udDBZXN41h81i7ZG77Ba3G1ewWZzuZnXg8tg56y67x6ZVnWwe
	d67tYfOYdzLQo2/LKkaPz5vkAtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jBm7Jizl6VgqnzFmg9vWRsYj0h2MXJySAiYSLy4/YkJwhaTuHBvPVsXIxeHkMB0Ronn946x
	QDivGSVmNd8Gq+IV0JJY1HAHzGYRUJVYe2UBO4jNBhTf/+IGG4gtKhAmsXL6FRaIekGJH5Pv
	gdkiAoYSB3dvZwIZyizwnkli6+yZYIOEBXwlzq+fwgyxrZVRYuH5j8wgCU4BD4nrCw6CTWUW
	0JHY3zoNypaX2LzmLfMERoFZSJbMQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5
	mxjB0f9MagfjygaLQ4wCHIxKPLweE3yChVgTy4orcw8xSnAwK4nwvk4GCvGmJFZWpRblxxeV
	5qQWH2JMBobBRGYp0eR8YGLKK4k3NDYxM7I0Mje0MDI2J01YSZz3QKt1oJBAemJJanZqakFq
	EcwWJg5OqQbGXTdXqVfZ/jmxdGMS387o2e/fsOSfdBbyt+8/sJB9TfjEw/d2fpxvtm3lr0mT
	/r8sbHjMcozhqL/0qQNfLjiebZryfcrX7zci9Tzbygv8fjElae1RbztpfqI0Wz1F6MX9nkNN
	301O/v/PLHrn6lS/uvzfnOErXzLmi1XxJl2s1NlbvfB+7EU5eyWW4oxEQy3mouJEAG8SHTxC	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 04/14/2014 06:17 PM, Krzysztof Kozlowski wrote:
> This patch prepares for adding support for MAX77836 device to existing
> max14577 driver by adding MAX14577 prefix to defines of interrupts.
> 
> This is only a rename-like patch, new code is not added.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/max14577.c               | 24 ++++++++++++------------
>  include/linux/mfd/max14577-private.h | 28 ++++++++++++++--------------
>  2 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> index 0e07ed74ab41..6f39dec9dfdf 100644
> --- a/drivers/mfd/max14577.c
> +++ b/drivers/mfd/max14577.c
> @@ -66,20 +66,20 @@ static const struct regmap_config max14577_muic_regmap_config = {
>  
>  static const struct regmap_irq max14577_irqs[] = {
>  	/* INT1 interrupts */
> -	{ .reg_offset = 0, .mask = INT1_ADC_MASK, },
> -	{ .reg_offset = 0, .mask = INT1_ADCLOW_MASK, },
> -	{ .reg_offset = 0, .mask = INT1_ADCERR_MASK, },
> +	{ .reg_offset = 0, .mask = MAX14577_INT1_ADC_MASK, },
> +	{ .reg_offset = 0, .mask = MAX14577_INT1_ADCLOW_MASK, },
> +	{ .reg_offset = 0, .mask = MAX14577_INT1_ADCERR_MASK, },
>  	/* INT2 interrupts */
> -	{ .reg_offset = 1, .mask = INT2_CHGTYP_MASK, },
> -	{ .reg_offset = 1, .mask = INT2_CHGDETRUN_MASK, },
> -	{ .reg_offset = 1, .mask = INT2_DCDTMR_MASK, },
> -	{ .reg_offset = 1, .mask = INT2_DBCHG_MASK, },
> -	{ .reg_offset = 1, .mask = INT2_VBVOLT_MASK, },
> +	{ .reg_offset = 1, .mask = MAX14577_INT2_CHGTYP_MASK, },
> +	{ .reg_offset = 1, .mask = MAX14577_INT2_CHGDETRUN_MASK, },
> +	{ .reg_offset = 1, .mask = MAX14577_INT2_DCDTMR_MASK, },
> +	{ .reg_offset = 1, .mask = MAX14577_INT2_DBCHG_MASK, },
> +	{ .reg_offset = 1, .mask = MAX14577_INT2_VBVOLT_MASK, },
>  	/* INT3 interrupts */
> -	{ .reg_offset = 2, .mask = INT3_EOC_MASK, },
> -	{ .reg_offset = 2, .mask = INT3_CGMBC_MASK, },
> -	{ .reg_offset = 2, .mask = INT3_OVP_MASK, },
> -	{ .reg_offset = 2, .mask = INT3_MBCCHGERR_MASK, },
> +	{ .reg_offset = 2, .mask = MAX14577_INT3_EOC_MASK, },
> +	{ .reg_offset = 2, .mask = MAX14577_INT3_CGMBC_MASK, },
> +	{ .reg_offset = 2, .mask = MAX14577_INT3_OVP_MASK, },
> +	{ .reg_offset = 2, .mask = MAX14577_INT3_MBCCHGERR_MASK, },
>  };
>  
>  static const struct regmap_irq_chip max14577_irq_chip = {
> diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
> index 1ce6f2952cc9..989183d232cd 100644
> --- a/include/linux/mfd/max14577-private.h
> +++ b/include/linux/mfd/max14577-private.h
> @@ -79,20 +79,20 @@ enum max14577_muic_charger_type {
>  };
>  
>  /* MAX14577 interrupts */
> -#define INT1_ADC_MASK			(0x1 << 0)
> -#define INT1_ADCLOW_MASK		(0x1 << 1)
> -#define INT1_ADCERR_MASK		(0x1 << 2)
> -
> -#define INT2_CHGTYP_MASK		(0x1 << 0)
> -#define INT2_CHGDETRUN_MASK		(0x1 << 1)
> -#define INT2_DCDTMR_MASK		(0x1 << 2)
> -#define INT2_DBCHG_MASK			(0x1 << 3)
> -#define INT2_VBVOLT_MASK		(0x1 << 4)
> -
> -#define INT3_EOC_MASK			(0x1 << 0)
> -#define INT3_CGMBC_MASK			(0x1 << 1)
> -#define INT3_OVP_MASK			(0x1 << 2)
> -#define INT3_MBCCHGERR_MASK		(0x1 << 3)
> +#define MAX14577_INT1_ADC_MASK		BIT(0)
> +#define MAX14577_INT1_ADCLOW_MASK	BIT(1)
> +#define MAX14577_INT1_ADCERR_MASK	BIT(2)
> +
> +#define MAX14577_INT2_CHGTYP_MASK	BIT(0)
> +#define MAX14577_INT2_CHGDETRUN_MASK	BIT(1)
> +#define MAX14577_INT2_DCDTMR_MASK	BIT(2)
> +#define MAX14577_INT2_DBCHG_MASK	BIT(3)
> +#define MAX14577_INT2_VBVOLT_MASK	BIT(4)
> +
> +#define MAX14577_INT3_EOC_MASK		BIT(0)
> +#define MAX14577_INT3_CGMBC_MASK	BIT(1)
> +#define MAX14577_INT3_OVP_MASK		BIT(2)
> +#define MAX14577_INT3_MBCCHGERR_MASK	BIT(3)
>  
>  /* MAX14577 DEVICE ID register */
>  #define DEVID_VENDORID_SHIFT		0
> 

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>

Cheers,
Chanwoo Choi
