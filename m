Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaF3AFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 20:05:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21234 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaF3AFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 20:05:20 -0400
X-AuditID: cbfee68f-b7fef6d000003970-ae-53b0a9bd5bfd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rickard Strandqvist'" <rickard_strandqvist@spectrumdigital.se>
Cc: "'Wolfram Sang'" <wsa@the-dreams.de>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Leilei Shang'" <shangll@marvell.com>,
        "'Peter Korsgaard'" <peter@korsgaard.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404084516-901-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1404084516-901-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-reply-to: <1404084516-901-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
Subject: Re: [PATCH v2] i2c: busses: i2c-pxa.c:  Fix for possible null pointer
 dereferenc
Date: Mon, 30 Jun 2014 09:05:16 +0900
Message-id: <009301cf93f6$f938a270$eba9e750$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+T8bID/pUhjiGvTPKBNfDS/U4xzwAA7w0w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+Zoe7elRuCDdb3slvMP3KO1eLAnx2M
	FpcXXmK16Pj7BcjaNYfNYnX3ARaL0ztvslq07j3CbtHx8iCbxcoTs5gduDw2repk8/j6dS6j
	x51re9g8Ji+8yOzRt2UVo0d7w09Gj5OnnrB4fN4kF8ARxWWTkpqTWZZapG+XwJVxbMkZ1oK1
	ihU9+6cxNjBek+xi5OSQEDCROLW0iQXCFpO4cG89WxcjF4eQwDJGiQ9L/rHAFPVd3ckEkZjO
	KLG7bz4rhPObUeLhoQ/sIFVsAmoSX74cBrNFBJwkfq7oYQEpYhY4wiSx+dByRpCEkMBCRomN
	5zVBbE6BcImb3ycxg9jCAtES79Z9A1vHIqAq8fTQM7A4r4CtxJ/2Z0wQtqDEj8n3wGqYBbQk
	1u88zgRhy0tsXvMWqJ4D6FR1iUd/dSFuMJJYuu04G0SJiMS+F+8YIb6ZyiGxaL8IxCoBiW+T
	D7FAtMpKbDrADFEiKXFwxQ2WCYwSs5AsnoVk8Swki2ch2bCAkWUVo2hqQXJBcVJ6kbFecWJu
	cWleul5yfu4mRkjs9+9gvHvA+hBjMtD6icxSosn5wNSRVxJvaGxmZGFqYmpsZG5pRpqwkjjv
	/YdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYA7f9mdKXq1xUUz/Zq87Ib96VpGa+D0ee
	fT4/+d8Ldc7l5QaKXc98nr+4Kr5pzbc8jgkq2scSDmcVcN1bwCAdUHH5Xu+WgI48D2Wmk2rW
	2rez5/jXmYgfVDjn5NK9mjPxpe3pvPtcm+7a+syTZf6nI69wITNsgv+JewUaSiyhUayVhSY1
	SiZKLMUZiYZazEXFiQCM2LxmEwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jQd29KzcEG7xewmQx/8g5VosDf3Yw
	WlxeeInVouPvFyBr1xw2i9XdB1gsTu+8yWrRuvcIu0XHy4NsFitPzGJ24PLYtKqTzePr17mM
	Hneu7WHzmLzwIrNH35ZVjB7tDT8ZPU6eesLi8XmTXABHVAOjTUZqYkpqkUJqXnJ+SmZeuq2S
	d3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QlUoKZYk5pUChgMTiYiV9O0wTQkPcdC1g
	GiN0fUOC4HqMDNBAwjrGjGNLzrAWrFWs6Nk/jbGB8ZpkFyMnh4SAiUTf1Z1MELaYxIV769m6
	GLk4hASmM0rs7pvPCuH8ZpR4eOgDO0gVm4CaxJcvh8FsEQEniZ8relhAipgFjjBJbD60nBEk
	ISSwkFFi43lNEJtTIFzi5vdJzCC2sEC0xLt131hAbBYBVYmnh56BxXkFbCX+tD9jgrAFJX5M
	vgdWwyygJbF+53EmCFteYvOat0D1HECnqks8+qsLcYORxNJtx9kgSkQk9r14xziBUWgWkkmz
	kEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEp5Zn0jsYVzVYHGIU4GBU
	4uHVWLYhWIg1say4MvcQowQHs5IIr1AdUIg3JbGyKrUoP76oNCe1+BCjKdCjE5mlRJPzgWkv
	ryTe0NjEzMjSyMzCyMTcXEmc92CrdaCQQHpiSWp2ampBahFMHxMHp1QDY0FxYM+d/06HWFb8
	u/JAWv3ltrPb55s5H16vFX7sFKPr3mPzwjP+CxoctzT4IXCY/YZwVqW9y5SYzFPcR7xkFy/0
	3t6Ts3ZFruiu1HCFC0JOZ3MkO63lJ7GnW174Ux/gt1IwzKtv9pFo4c1ztrwWkL2y4K5MMq+F
	3+1HN07MWS3y4XrnTbOYv0osxRmJhlrMRcWJAEi6ZUJDAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 30, 2014 8:29 AM, Rickard Strandqvist wrote:
> 
> Fix for possible null pointer dereferenc, and there is a risk for memory leak in when something
> unexpected happens and the function returns.

Would you split the patch into two patches?

  [PATCH 1/2] i2c: pxa: Fix for possible null pointer dereference
  [PATCH 2/2] i2c: pxa: Use devm_* functions

> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/i2c/busses/i2c-pxa.c |   37 ++++++++++++++++---------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> index be671f7..886877a 100644
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
> +	i2c->reg_base = devm_ioremap(&dev->dev, res->start, resource_size(res));
> +	if (IS_ERR(i2c->reg_base)) {

Did you check what devm_ioremap() returns?
It returns 'valid addr value' Or NULL as below.
So, IS_ERR() should NOT be used.

./lib/devres.c

void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
                           unsigned long size)
{
        void __iomem **ptr, *addr;

        ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
        if (!ptr)
                return NULL;

        addr = ioremap(offset, size);
        if (addr) {
                *ptr = addr;
                devres_add(dev, ptr);
        } else
                devres_free(ptr);

        return addr;
}
EXPORT_SYMBOL(devm_ioremap);

Best regards,
Jingoo Han

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
> +err_nothing_to_release:
>  	return ret;
>  }
> 
> --
> 1.7.10.4

