Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab3FJFfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 01:35:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30169 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3FJFe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 01:34:59 -0400
X-AuditID: cbfee691-b7fef6d000002d62-fb-51b56581c643
From: Jingoo Han <jg1.han@samsung.com>
To: "'Emil Goode'" <emilgoode@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Andrew Lunn <andrew@lunn.ch>, Bill Pemberton <wfp5p@virginia.edu>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
References: <1370822442-25217-1-git-send-email-emilgoode@gmail.com>
In-reply-to: <1370822442-25217-1-git-send-email-emilgoode@gmail.com>
Subject: Re: [PATCH v2] mtd: orion_nand: Improve error handling in
 orion_nand_probe
Date: Mon, 10 Jun 2013 14:34:57 +0900
Message-id: <001e01ce659c$3e582270$bb086750$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQMbR6Kq/ihb14HhXWZ1cYv/fVMtwJaUoosQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+ZkW5j6tZAg9Z1Vhbn7x5itng54TCj
	xZvHz5gtXv+bzmIxceVkZouWJ4vYLS4vvMRqsfWWtMXlXXPYLHY3LWO3WPX/LIsDt8fOWXfZ
	PTav0PKYdzLQY/OSeo+dOz4zeXx8eovFo2/LKkaPz5vkPF4cf8kUwBnFZZOSmpNZllqkb5fA
	lbF57y+2gocqFS1Pr7E1MH6V6WLk5JAQMJG4tvUSO4QtJnHh3nq2LkYuDiGBZYwSP+7NYIcp
	+tdzjQUiMZ1RYt/MY1DOL0aJrp87WEGq2ATUJL58OQzWIQJkP3n3GGwUs0AHs8SZlg42kISQ
	gLPEqQ1zmUFsTgEXiT1trYwgtrBAqMSklbuZQGwWAVWJ//M3soDYvAKWEpc7Ie7jFRCU+DH5
	HlicWUBLYv3O40wQtrzE5jVvmSFOVZDYcfY1I8QRRhIXznxhg6gRkdj34h0jyEESAgs5JGZt
	O8AKsUxA4tvkQ0BDOYASshKbDkDNkZQ4uOIGywRGiVlIVs9CsnoWktWzkKxYwMiyilE0tSC5
	oDgpvchUrzgxt7g0L10vOT93EyMkFUzcwXj/gPUhxmSg9ROZpUST84GpJK8k3tDYzMjC1MTU
	2Mjc0ow0YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjIvqEjy3ePPZb9hwuGFq
	0i+fq+LXz71e8MX+hrlN3brDd/clT+R7MXObynPdbaadwmpfeljvS/yx/vPe4HbRBY1DO2Ze
	sbx3YorILrP/FxmCdyxW2Zn4Y/+6W1s9LhddX+Y9qdwoobZh7fOKxT1n79cuu/6pSqSno3JO
	WtC777ELtz15LRrm9m+DEktxRqKhFnNRcSIAchjaMxsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsVy+t9jQd3G1K2BBt1vTCzO3z3EbPFywmFG
	izePnzFbvP43ncVi4srJzBYtTxaxW1xeeInVYustaYvLu+awWexuWsZuser/WRYHbo+ds+6y
	e2xeoeUx72Sgx+Yl9R47d3xm8vj49BaLR9+WVYwenzfJebw4/pIpgDOqgdEmIzUxJbVIITUv
	OT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hWJYWyxJxSoFBAYnGxkr4d
	pgmhIW66FjCNEbq+IUFwPUYGaCBhHWPG5r2/2AoeqlS0PL3G1sD4VaaLkZNDQsBE4l/PNRYI
	W0ziwr31bF2MXBxCAtMZJfbNPMYC4fxilOj6uYMVpIpNQE3iy5fD7CC2CJD95N1jsA5mgQ5m
	iTMtHWwgCSEBZ4lTG+Yyg9icAi4Se9paGUFsYYFQiUkrdzOB2CwCqhL/528EW80rYClxufMS
	O4QtKPFj8j2wOLOAlsT6nceZIGx5ic1r3jJDnKogsePsa0aII4wkLpz5wgZRIyKx78U7xgmM
	QrOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM40TyT2sG4ssHi
	EKMAB6MSD++DX1sChVgTy4orcw8xSnAwK4nw/rTcGijEm5JYWZValB9fVJqTWnyIMRno04nM
	UqLJ+cAkmFcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjGfi
	YztOPRG/skH0Tuj9lZHLipT2HN3lVvCF4VJxoUfJheQNjsKVnhtX3i8RkHeQ5pksKL3WZv2i
	/Sl1CqefRkyQEvjWOU89ea7J9PXngycyPLs7KyC75OocF8GeAP4uzluG2iezu7VWnD25uPTh
	vV3CjInvxfq2fpOd/zVa/jyrpe8yO52zV5RYijMSDbWYi4oTAT6ez7F4AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Monday, June 10, 2013 9:01 AM, Emil Goode wrote:
> 
> This patch fixes some issues in the error handling and simplifies
> the code by converting to devm* functions.
> 
> If the kzalloc call fails it is unnecessary to use the label no_res
> and pass a NULL pointer to kfree. If the devm_kzalloc call fails on
> line 110 we forget to call iounmap for the previous ioremap call.
> 
> The following changes are introduced:
> - Convert to devm_kzalloc and remove calls to kfree.
> - Convert to devm_ioremap_resource that adds a missing call to
>   *request_mem_region and remove calls to iounmap.
> - The devm_ioremap_resource function checks the passed resource so
>   we can remove the NULL check after the platform_get_resource call.
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
> This patch is only build tested
> v2: Fix change log typo and remove error messages for kzalloc calls
> 
>  drivers/mtd/nand/orion_nand.c |   49 +++++++++++++----------------------------
>  1 file changed, 15 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
> index 8fbd002..76b9fba 100644
> --- a/drivers/mtd/nand/orion_nand.c
> +++ b/drivers/mtd/nand/orion_nand.c
> @@ -85,35 +85,24 @@ static int __init orion_nand_probe(struct platform_device *pdev)
>  	int ret = 0;
>  	u32 val = 0;
> 
> -	nc = kzalloc(sizeof(struct nand_chip) + sizeof(struct mtd_info), GFP_KERNEL);
> -	if (!nc) {
> -		printk(KERN_ERR "orion_nand: failed to allocate device structure.\n");

CC'ed Dan Carpenter, Andy Shevchenko

You don't need to remove this error message.
You would replace 'printk(KERN_ERR "orion_nand:...)' with
'dev_err(&pdev->dev,)'.

	dev_err("failed to allocate device structure.\n");


> -		ret = -ENOMEM;
> -		goto no_res;
> -	}
> +	nc = devm_kzalloc(&pdev->dev, sizeof(struct nand_chip) +
> +			  sizeof(struct mtd_info), GFP_KERNEL);
> +	if (!nc)
> +		return -ENOMEM;
> +
>  	mtd = (struct mtd_info *)(nc + 1);
> 
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		ret = -ENODEV;
> -		goto no_res;
> -	}
> -
> -	io_base = ioremap(res->start, resource_size(res));
> -	if (!io_base) {
> -		printk(KERN_ERR "orion_nand: ioremap failed\n");

Yes, this error message is not necessary.
devm_ioremap_resource() provides its own error messages; so all
explicit error messages can be removed from the failure code paths.


> -		ret = -EIO;
> -		goto no_res;
> -	}
> +	io_base = devm_ioremap_resource(&pdev->dev, res);

How about using devm_ioremap() instead of devm_ioremap_resource()?

Only ioremap() was used previously; however, devm_ioremap_resource()
internally calls both devm_request_mem_region() and devm_ioremap().

If it is wrong, please let me know kindly. :)


> +	if (IS_ERR(io_base))
> +		return PTR_ERR(io_base);
> 
>  	if (pdev->dev.of_node) {
>  		board = devm_kzalloc(&pdev->dev, sizeof(struct orion_nand_data),
> -					GFP_KERNEL);
> -		if (!board) {
> -			printk(KERN_ERR "orion_nand: failed to allocate board structure.\n");

As above mentioned, you don't need to remove this error message.
You would replace 'printk(KERN_ERR "orion_nand:...)' with
'dev_err(&pdev->dev,)'.

	dev_err("failed to allocate board structure.\n");


Best regards,
Jingoo Han


> -			ret = -ENOMEM;
> -			goto no_res;
> -		}
> +				     GFP_KERNEL);
> +		if (!board)
> +			return -ENOMEM;
> +
>  		if (!of_property_read_u32(pdev->dev.of_node, "cle", &val))
>  			board->cle = (u8)val;
>  		else
> @@ -167,7 +156,7 @@ static int __init orion_nand_probe(struct platform_device *pdev)
> 
>  	if (nand_scan(mtd, 1)) {
>  		ret = -ENXIO;
> -		goto no_dev;
> +		goto disable_clk;
>  	}
> 
>  	mtd->name = "orion_nand";
> @@ -176,20 +165,17 @@ static int __init orion_nand_probe(struct platform_device *pdev)
>  			board->parts, board->nr_parts);
>  	if (ret) {
>  		nand_release(mtd);
> -		goto no_dev;
> +		goto disable_clk;
>  	}
> 
>  	return 0;
> 
> -no_dev:
> +disable_clk:
>  	if (!IS_ERR(clk)) {
>  		clk_disable_unprepare(clk);
>  		clk_put(clk);
>  	}
>  	platform_set_drvdata(pdev, NULL);
> -	iounmap(io_base);
> -no_res:
> -	kfree(nc);
> 
>  	return ret;
>  }
> @@ -197,15 +183,10 @@ no_res:
>  static int orion_nand_remove(struct platform_device *pdev)
>  {
>  	struct mtd_info *mtd = platform_get_drvdata(pdev);
> -	struct nand_chip *nc = mtd->priv;
>  	struct clk *clk;
> 
>  	nand_release(mtd);
> 
> -	iounmap(nc->IO_ADDR_W);
> -
> -	kfree(nc);
> -
>  	clk = clk_get(&pdev->dev, NULL);
>  	if (!IS_ERR(clk)) {
>  		clk_disable_unprepare(clk);
> --
> 1.7.10.4

