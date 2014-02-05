Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaBEArI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:47:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10479 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaBEArF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:47:05 -0500
X-AuditID: cbfee68f-b7f156d00000276c-ed-52f18a089ede
Message-id: <52F18A08.6070409@samsung.com>
Date: Wed, 05 Feb 2014 09:47:04 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 11/18] extcon: max14577: Add max14577 prefix to muic_irqs
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-12-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1390911522-28209-12-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWyRsSkSJej62OQwcJ2QYupD5+wWbx+YWhx
	tukNu8X9r0cZLb5d6WCy2PT4GqvF5V1z2CzWHrnLbnG7cQWbxeluVgcuj52z7rJ7bFrVyeZx
	59oeNo95JwM9Ni+p9+jbsorR4/MmuQD2KC6blNSczLLUIn27BK6MY8sOsxRMFqlo/LmMrYFx
	l0AXIyeHhICJRO/eZawQtpjEhXvr2boYuTiEBJYySqw/8ocVpmh3wwNmiMR0Romdl8+xQjiv
	GCUm9C5kBqniFdCSePuhgQnEZhFQlfh27xYbiM0GFN//4gaYLSoQJrFy+hUWiHpBiR+T74HZ
	IgKGEgd3bwfrZRa4zySx6ogOiC0s4CuxfNpRRhBbSKCNUaK7Ww/E5hTwlLjTfY8Zol5HYn/r
	NDYIW15i85q3YJdKCLxll7jbvYId4iABiW+TDwEt4wBKyEpsOsAM8ZmkxMEVN1gmMIrNQnLS
	LCRjZyEZu4CReRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYIye/vesfwfj3QPWhxiTgVZO
	ZJYSTc4HxnheSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamBUqyve8q7oRf7KKx7XpDIb9LRj7wcsnLeoS6j+XvSGzEs3uA677DNxPM9077y6VfKz
	nNw1ic/C4sS2tr6YzH2b3/zdRof60+fSVih01/spJl/Wlj2QDUyLenvvV1/dKc9ntDgpuH1G
	uPCM0KlNe1fXzvvUYmXs/r77tIx31g6HpVHJGuXnGZVYijMSDbWYi4oTAV96GbjnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jQV2Oro9BBkd+cVhMffiEzeL1C0OL
	s01v2C3ufz3KaPHtSgeTxabH11gtLu+aw2ax9shddovbjSvYLE53szpweeycdZfdY9OqTjaP
	O9f2sHnMOxnosXlJvUffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7H
	yAANJKxhzDi27DBLwWSRisafy9gaGHcJdDFyckgImEjsbnjADGGLSVy4t56ti5GLQ0hgOqPE
	zsvnWCGcV4wSE3oXglXxCmhJvP3QwARiswioSny7d4sNxGYDiu9/cQPMFhUIk1g5/QoLRL2g
	xI/J98BsEQFDiYO7t4P1MgvcZ5JYdUQHxBYW8JVYPu0oI4gtJNDGKNHdrQdicwp4StzpvscM
	Ua8jsb91GhuELS+xec1b5gmMArOQrJiFpGwWkrIFjMyrGEVTC5ILipPSc430ihNzi0vz0vWS
	83M3MYITwDPpHYyrGiwOMQpwMCrx8BoIfwwSYk0sK67MPcQowcGsJMK7tg0oxJuSWFmVWpQf
	X1Sak1p8iDEZGAITmaVEk/OBySmvJN7Q2MTMyNLI3NDCyNicNGElcd6DrdaBQgLpiSWp2amp
	BalFMFuYODilGhjl28z33tX62HRAK3FepueflR8TL0V+UD46hzfEoMf3wh3+x079X+U3VCXv
	1bV5vOh1tnF01GQHwZIMcetVq3UY4v+8ePlyVmNmvl7znR8pZovt55y+PT8hUCww6Njimu4b
	mZeznFyKCjjNJjKI8P99sNsqvMJveYoG9w2u12c8lizY6NBZKKXEUpyRaKjFXFScCACiiVA6
	RAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

Following patch has conflict on extcon-next branch(Linus 3.14-rc1)
when apply patchset by using git am.

[PATCH 11/18] extcon: max14577: Add max14577 prefix to muic_irqs
[PATCH 12/18] extcon: max14577: Choose muic_irqs according to device type
[PATCH 14/18] extcon: max14577: Add support for max77836

The base commit of this patchset isn't mainline. You need to rebase this patchset 
on extcon-next branch and please resend this patchset.

Thanks,
Chanwoo Choi

On 01/28/2014 09:18 PM, Krzysztof Kozlowski wrote:
> Add max14577 prefix to muic_irqs array. This prepares for max77836
> support in this extcon driver.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/extcon/extcon-max14577.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
> index fd48b4909470..fb343f4042d2 100644
> --- a/drivers/extcon/extcon-max14577.c
> +++ b/drivers/extcon/extcon-max14577.c
> @@ -85,7 +85,7 @@ struct max14577_muic_irq {
>  	unsigned int virq;
>  };
>  
> -static struct max14577_muic_irq muic_irqs[] = {
> +static struct max14577_muic_irq max14577_muic_irqs[] = {
>  	{ MAXIM_IRQ_INT1_ADC,		"muic-ADC" },
>  	{ MAXIM_IRQ_INT1_ADCLOW,	"muic-ADCLOW" },
>  	{ MAXIM_IRQ_INT1_ADCERR,	"muic-ADCError" },
> @@ -541,9 +541,9 @@ static irqreturn_t max14577_muic_irq_handler(int irq, void *data)
>  	 * However we only need to know whether it was ADC, charger
>  	 * or both interrupts so decode IRQ and turn on proper flags.
>  	 */
> -	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++)
> -		if (irq == muic_irqs[i].virq)
> -			irq_type = muic_irqs[i].irq;
> +	for (i = 0; i < ARRAY_SIZE(max14577_muic_irqs); i++)
> +		if (irq == max14577_muic_irqs[i].virq)
> +			irq_type = max14577_muic_irqs[i].irq;
>  
>  	switch (irq_type) {
>  	case MAXIM_IRQ_INT1_ADC:
> @@ -647,8 +647,8 @@ static int max14577_muic_probe(struct platform_device *pdev)
>  	INIT_WORK(&info->irq_work, max14577_muic_irq_work);
>  
>  	/* Support irq domain for max14577 MUIC device */
> -	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++) {
> -		struct max14577_muic_irq *muic_irq = &muic_irqs[i];
> +	for (i = 0; i < ARRAY_SIZE(max14577_muic_irqs); i++) {
> +		struct max14577_muic_irq *muic_irq = &max14577_muic_irqs[i];
>  		unsigned int virq = 0;
>  
>  		virq = regmap_irq_get_virq(maxim_core->irq_data_muic,
> 

