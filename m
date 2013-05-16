Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab3EPIUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:20:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35674 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab3EPIU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:20:28 -0400
X-AuditID: cbfee68e-b7f276d000002279-fc-519496a723d6
Date: Thu, 16 May 2013 08:19:51 +0000 (GMT)
From: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH V2] drivers: mmc: host: use devm_ioremap_resource()
To: Laurent Navet <laurent.navet@gmail.com>, "cjb@laptop.org" <cjb@laptop.org>
Cc: "nico@fluxnic.net" <nico@fluxnic.net>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Jingoo Han <jg1.han@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: jg1.han@samsung.com
MIME-version: 1.0
X-MTR: 20130516081817634@jg1.han
Msgkey: 20130516081817634@jg1.han
X-EPLocale: en_US.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130516081817634@jg1.han
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <4876879.136041368692387848.JavaMail.weblogic@epml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsVy+t8zfd0V06YEGhzrYrS4vGsOmwOjx+dN
	cgGMUQ2MNolFyRmZZakKqXnJ+SmZeem2SqEhbroWSgoZ+cUltkrRRgbGekamJnpGJuZ6lgax
	VkamSgp5ibmptkoVulC9SgpFyQVAtbmVxUADclL1oOJ6xal5KQ5Z+aUgl+gVJ+YWl+al6yXn
	5yoplCXmlAKNUNJPmMqY8bxhK2PBNu6KP+s3Mzcw9nB3MXJyCAkoSUw6uZcRxJYQMJFY++MC
	K4QtJnHh3nq2LkYuoJpljBLnL16DK+rctoMVIjGfUaJ11UNmkASLgKrEr/NnwGw2AXWJCb+b
	WUBsYQF3ibYHT4EaODhEBIIkdnzVB+llFljOLNH8ZworxBWyEvcmzwbr5RUQlDg58wkLSL2E
	gILEnj2lEGFFibutn5kgbpCQuHN/P9ShvBIz2p+yQNhyEtO+rmGGsKUlzs/awAjzzOLvj6Hi
	/BLHbu9gghjPK/HkfjDMmN2bv7BB2AISU88chGpVlTj54DHUeD6JNQvfQtmCEqevdTPD9N7f
	MhfsNGagM6d0P2SHsLUkvvzYx4buK14BR4mGDvEJjMqzkGRmIemehaQbWc0CRpZVjKKpBckF
	xUnpRUbIcb2JEZIE+3Yw3jxgfYhxPyMwRiYyS4km5wPTaF5JvKGxmZGFqYmpsZG5pRmFwiam
	FhYmRlQRVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAWOORuTZshYmbYmRR95nJ
	1ZVrI0w+X/67SqN2+Qa7xi0Hork0v7LtFziY1H57Nttqj8pb7CxK+3vLOrY8YZ2VLr6z6Sp3
	yo0ncncZOwXclhmXXppy4GhmbZVM+77fVdqC0xepHZh4zrDjt/wJqYm7+t+K2+uaPzhUdTJv
	piz3ho2P9/PV9R/YpsRSnJFoqMVcVJwIAOmVOG/1AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2DN3l06YEGqz6Z2VxedccNgdGj8+b
	5AIYozJsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaKNDIz1jExN9IyMDfSMLWOtDA0MjEyBqhIy
	Mp43bGUs2MZd8Wf9ZuYGxh7uLkZODiEBJYlJJ/cygtgSAiYSndt2sELYYhIX7q1n62LkAqqZ
	zyjRuuohM0iCRUBV4tf5M2A2m4C6xITfzSwgtrCAu0Tbg6dAzRwcIgJBEju+6oP0MgssZ5Zo
	/jOFFWKZrMS9ybPBenkFBCVOznzCAlIvIaAgsWdPKURYUeJu62cmiBskJO7c3w91D6/EjPan
	LBC2nMS0r2uYIWxpifOzNjDC3Lz4+2OoOL/Esds7mCDG80o8uR8MM2b35i9sELaAxNQzB6Fa
	VSVOPngMNZ5PYs3Ct1C2oMTpa93MML33t8wFO40Z6Mwp3Q/ZIWwtiS8/9rGh+4pXwFGioUN8
	AqPcLCSZWUi6ZyHpRlazgJFlFaNoakFyQXFSeoWRXnFibnFpXrpecn7uJkZwenq2aAfjv/PW
	hxgFOBiVeHhPJEwJFGJNLCuuzD3EKMHBrCTCOyMVKMSbklhZlVqUH19UmpNafIgxGRh9E5ml
	RJPzgakzryTe0NjYxMzE1NzAwsDSnDRhJXHeZ63WgUIC6YklqdmpqQWpRTBbmDg4pRoY2/k9
	6j+tOx60Z9KEzKk2kpPj/t36szklMmlVbF/iT2nvo0q8m/aHmIrM17wWnd+amKpz99w+q0uP
	LvSGXT7E+Zvp4NqKpKNmGy9NjDjyrTNgbr7wLoGXSu8jT4ord0wP+7t8S3Qzz6SJnY8nh7tO
	MEsR91DJW6rwIu1rd/XTDzzPubfarBR7rcRSnJFoqMVcVJwIABNo2nOTAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4G8Kijd020814

Thursday, May 16, 2013 5:22 PM, Laurent Navet wrote:
> 
> Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.
> 
> Found with coccicheck and this semantic patch:
>  scripts/coccinelle/api/devm_ioremap_resource.cocci
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com

Best regards,
Jingoo Han

> ---
>  drivers/mmc/host/mvsdio.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
> index 8960fc8..a66ee4b 100644
> --- a/drivers/mmc/host/mvsdio.c
> +++ b/drivers/mmc/host/mvsdio.c
> @@ -758,9 +758,9 @@ static int __init mvsd_probe(struct platform_device *pdev)
> 
>  	spin_lock_init(&host->lock);
> 
> -	host->base = devm_request_and_ioremap(&pdev->dev, r);
> -	if (!host->base) {
> -		ret = -ENOMEM;
> +	host->base = devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(host->base)) {
> +		ret = PTR_ERR(host->base);
>  		goto out;
>  	}
> 
> --
> 1.7.10.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
