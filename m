Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964933AbaGDACO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 20:02:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43591 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600AbaGDACL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 20:02:11 -0400
X-AuditID: cbfee690-b7fb56d000003439-9f-53b5ef0019d3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rickard Strandqvist'" <rickard_strandqvist@spectrumdigital.se>
Cc: "'Wolfram Sang'" <wsa@the-dreams.de>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Leilei Shang'" <shangll@marvell.com>,
        "'Peter Korsgaard'" <peter@korsgaard.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404418756-10550-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1404418756-10550-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-reply-to: <1404418756-10550-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
Subject: Re: [PATCH v3] i2c: busses: i2c-pxa.c:  Fix for possible null pointer
 dereferenc
Date: Fri, 04 Jul 2014 09:02:07 +0900
Message-id: <002401cf971b$32209120$9661b360$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+W++bKP0rbb6u7ST6txw5sncQwIAAHpSAA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+ZgS7D+63BBjd6FC3mHznHanHgzw5G
	i8sLL7FadPz9AmTtmsNmsbr7AIvF6Z03WS1a9x5ht+h4eZDNYuWJWcwOXB6bVnWyeXz9OpfR
	4861PWwekxdeZPbo27KK0aO94Sejx8lTT1g8Pm+SC+CI4rJJSc3JLEst0rdL4Mr4e6GXveCD
	TMWPk9/YGhj/iHUxcnJICJhILO/4xARhi0lcuLeerYuRi0NIYBmjxI/p2xlhio68XssCYgsJ
	LGKUWH5dH6LoN6PErobpYAk2ATWJL18Os4PYIgJOEj9X9LCAFDELHGGS2HxoOSNEx1JGifmb
	fjGDVHEKREqcugNhCwtESxw/0MgKYrMIqEpc/3cA6A4ODl4BW4mOC4IgYV4BQYkfk++BLWMW
	0JJYv/M4E4QtL7F5zVtmkHIJAXWJR391IW4wkpg8YRIbRImIxL4X78BOkBCYyiGxbOp8NohV
	AhLfJh9igeiVldh0gBniYUmJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0otM
	9IoTc4tL89L1kvNzNzFCYn/CDsZ7B6wPMSYDrZ/ILCWanA9MHXkl8YbGZkYWpiamxkbmlmak
	CSuJ86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLhyepbxZ1ZN17TdEwQ2qohoqmtO
	ND17dentAr78RxLde+Z7PjDosFnaZP4j44PNTCOVXeGR4R1fuTk0JW6qN//ImXDzzrbTqYa6
	wof2rSjetXOfpaqppE/P+gyjXMsLsxgbtmsGzw/n1eqrqEkJK2baXnRnb98teZ8GG8cHG7fU
	tZc8/Ml8QomlOCPRUIu5qDgRAFROusATAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jAV2G91uDDbY2yVjMP3KO1eLAnx2M
	FpcXXmK16Pj7BcjaNYfNYnX3ARaL0ztvslq07j3CbtHx8iCbxcoTs5gduDw2repk8/j6dS6j
	x51re9g8Ji+8yOzRt2UVo0d7w09Gj5OnnrB4fN4kF8AR1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0pZJCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4x4++FXvaCDzIVP05+Y2tg/CPWxcjJISFgInHk9VoWCFtM4sK99Wwg
	tpDAIkaJ5df1uxi5gOzfjBK7GqaDFbEJqEl8+XKYHcQWEXCS+LmihwWkiFngCJPE5kPLGSE6
	ljJKzN/0ixmkilMgUuLUHQhbWCBa4viBRlYQm0VAVeL6vwNA6zg4eAVsJTouCIKEeQUEJX5M
	vge2jFlAS2L9zuNMELa8xOY1b5lByiUE1CUe/dWFuMFIYvKESWwQJSIS+168Y5zAKDQLyaRZ
	SCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCE8sz6R2MqxosDjEKcDAq
	8fB6FG0NFmJNLCuuzD3EKMHBrCTCu+IBUIg3JbGyKrUoP76oNCe1+BCjKdCfE5mlRJPzgUkv
	ryTe0NjEzMjSyMzCyMTcXEmc92CrdaCQQHpiSWp2ampBahFMHxMHp1QDY9bP42mcEwLu/lDd
	zvXnZ/CBsjupClv+no4s8Zyzqkut9e/bo+zPrF44LhJcXRjQZPz6RbvuwRM2b7IXvr6U+qq8
	fLrp4YQjT3dtEGtyDbZiCt4TZl3iZu/gl8K6aINF+r8NMuI5RtfiFrInNXvdXPTkHo99uHzd
	5EA2nbns+iZH78/0jl9prsRSnJFoqMVcVJwIAPT/6UFCAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 04, 2014 5:19 AM, Rickard Strandqvist wrote:
> 
> Fix for possible null pointer dereferenc, and there is a risk
> for memory leak if something unexpected

s/dereferenc/dereference

The columns of this commit is too long.
Please keep about 80 columns.

> happens and the function returns.
> It now use Managed Device Resource instead.

s/use/uses

> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/i2c/busses/i2c-pxa.c |   37 ++++++++++++++++---------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> index be671f7..2edb633 100644
> --- a/drivers/i2c/busses/i2c-pxa.c
> +++ b/drivers/i2c/busses/i2c-pxa.c
> @@ -1141,10 +1141,10 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  	struct resource *res = NULL;
>  	int ret, irq;
> 
> -	i2c = kzalloc(sizeof(struct pxa_i2c), GFP_KERNEL);
> +	i2c = devm_kzalloc(&dev->dev, sizeof(struct pxa_i2c), GFP_KERNEL);
>  	if (!i2c) {
>  		ret = -ENOMEM;
> -		goto emalloc;
> +		goto err_nothing_to_release;
>  	}
> 
>  	/* Default adapter num to device id; i2c_pxa_probe_dt can override. */
> @@ -1154,18 +1154,19 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  	if (ret > 0)
>  		ret = i2c_pxa_probe_pdata(dev, i2c, &i2c_type);
>  	if (ret < 0)
> -		goto eclk;
> +		goto err_nothing_to_release;
> 
>  	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
>  	irq = platform_get_irq(dev, 0);
>  	if (res == NULL || irq < 0) {
>  		ret = -ENODEV;
> -		goto eclk;
> +		goto err_nothing_to_release;
>  	}
> 
> -	if (!request_mem_region(res->start, resource_size(res), res->name)) {
> +	if (!devm_request_mem_region(&dev->dev, res->start,
> +				resource_size(res), res->name)) {
>  		ret = -ENOMEM;
> -		goto eclk;
> +		goto emalloc;
>  	}
> 
>  	i2c->adap.owner   = THIS_MODULE;
> @@ -1176,16 +1177,16 @@ static int i2c_pxa_probe(struct platform_device *dev)
> 
>  	strlcpy(i2c->adap.name, "pxa_i2c-i2c", sizeof(i2c->adap.name));
> 
> -	i2c->clk = clk_get(&dev->dev, NULL);
> +	i2c->clk = devm_clk_get(&dev->dev, NULL);
>  	if (IS_ERR(i2c->clk)) {
>  		ret = PTR_ERR(i2c->clk);
> -		goto eclk;
> +		goto emalloc;
>  	}
> 
> -	i2c->reg_base = ioremap(res->start, resource_size(res));
> -	if (!i2c->reg_base) {
> +	i2c->reg_base = devm_ioremap_resource(&adev->dev, res));
> +	if (IS_ERR(i2c->reg_base)) {
>  		ret = -EIO;
> -		goto eremap;
> +		goto emalloc;
>  	}
> 
>  	i2c->reg_ibmr = i2c->reg_base + pxa_reg_layout[i2c_type].ibmr;
> @@ -1227,10 +1228,10 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  		i2c->adap.algo = &i2c_pxa_pio_algorithm;
>  	} else {
>  		i2c->adap.algo = &i2c_pxa_algorithm;
> -		ret = request_irq(irq, i2c_pxa_handler, IRQF_SHARED,
> -				  dev_name(&dev->dev), i2c);
> +		ret = devm_request_irq(&dev->dev, irq, i2c_pxa_handler,
> +				 IRQF_SHARED, dev_name(&dev->dev), i2c);
>  		if (ret)
> -			goto ereqirq;
> +			goto emalloc;
>  	}
> 
>  	i2c_pxa_reset(i2c);
> @@ -1261,15 +1262,9 @@ static int i2c_pxa_probe(struct platform_device *dev)
>  eadapt:
>  	if (!i2c->use_pio)
>  		free_irq(irq, i2c);
> -ereqirq:
> -	clk_disable_unprepare(i2c->clk);
> -	iounmap(i2c->reg_base);
> -eremap:
> -	clk_put(i2c->clk);
> -eclk:
> -	kfree(i2c);
>  emalloc:
>  	release_mem_region(res->start, resource_size(res));

This function can be removed, because devm_request_mem_region()
is used. So, please remove release_mem_region().

Best regards,
Jingoo Han

> +err_nothing_to_release:
>  	return ret;
>  }
> 
> --
> 1.7.10.4

