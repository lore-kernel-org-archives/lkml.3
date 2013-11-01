Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3KACSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 22:18:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58105 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab3KACSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 22:18:21 -0400
X-AuditID: cbfee691-b7f866d000001b8c-de-52730f6b6175
From: Jingoo Han <jg1.han@samsung.com>
To: "'Wei Yongjun'" <weiyj.lk@gmail.com>
Cc: dwmw2@infradead.org, zonque@gmail.com, avinashphilip@ti.com,
        computersforpeace@gmail.com, artem.bityutskiy@linux.intel.com,
        pekon@ti.com, tony@atomide.com, yongjun_wei@trendmicro.com.cn,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <CAPgLHd8V06KzBcPmFywSfNxM0q6=s86xn-AdLKeY9h5JZ_nP7g@mail.gmail.com>
In-reply-to: <CAPgLHd8V06KzBcPmFywSfNxM0q6=s86xn-AdLKeY9h5JZ_nP7g@mail.gmail.com>
Subject: Re: [PATCH -next] mtd: nand: omap: fix error return code in
 omap_nand_probe()
Date: Fri, 01 Nov 2013 11:18:19 +0900
Message-id: <001101ced6a8$a18a2c80$e49e8580$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7Wl5gRyllnABoXQ26vajbgEFSE4QAELD9g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+ZgW42f3GQwbb7BhZvHj9jtnh0Zz+T
	xZELa5ktJq6czGxxeeElVovLu+awWexuWsZuMbthF5vF/iteFh8uHWW22Lmuk92ic8Z6Jgce
	j29fJ7F47Jx1l91j8wotj3knAz02L6n36NuyitHj+I3tTB5L7x1l9Pi8SS6AM4rLJiU1J7Ms
	tUjfLoEr48ffnIKnHBXnvy9hb2DsY+9i5OSQEDCROND8nhHCFpO4cG89WxcjF4eQwDJGiSft
	H5lhig5+3QmVWMQoceDqQyjnF6PExBUvwNrZBNQkvnw5DDZWBMg++reLFaSIWWAZk8S0zedY
	QRJCAgESE+Z+ARvLKRAssa27C6iBg0NYIEJi6WpvkDCLgKrE+l0z2EBsXgFbiUtv5rND2IIS
	PybfYwGxmQW0JNbvPM4EYctLbF7zlhlkjISAusSjv7oQJxhJdL5bxghRIiKx78U7RpBzJASW
	ckhcWLqKCWKXgMS3yYdYIHplJTYdgHpYUuLgihssExglZiHZPAvJ5llINs9CsmIBI8sqRtHU
	guSC4qT0IlO94sTc4tK8dL3k/NxNjJB0MHEH4/0D1ocYk4HWT2SWEk3OB6aTvJJ4Q2MzIwtT
	E1NjI3NLM9KElcR50x8lBQkJpCeWpGanphakFsUXleakFh9iZOLglGpg5G3PZVrAtDetY3HY
	xoC+NoFeXzW585XrPn5ssN7k8lw359fN5IAumXtJj+9yyDfH555oq+3xmHBGSDa8It/PSlWz
	JUAgNilv3fbQGcrHbUqZVPY/nL1w2ezQ1LUVc6WkLkVUvF5mHBh/tYxtWobzO6b7B/2NFsZf
	3JSsxPZnjsODkClFRwKVWIozEg21mIuKEwFZSbpkHQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOKsWRmVeSWpSXmKPExsVy+t9jAd1s/uIggy+dOhZvHj9jtnh0Zz+T
	xZELa5ktJq6czGxxeeElVovLu+awWexuWsZuMbthF5vF/iteFh8uHWW22Lmuk92ic8Z6Jgce
	j29fJ7F47Jx1l91j8wotj3knAz02L6n36NuyitHj+I3tTB5L7x1l9Pi8SS6AM6qB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GAlhbLEnFKgUEBi
	cbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8aPvzkFTzkqzn9fwt7A2MfexcjJISFgInHw
	6042CFtM4sK99UA2F4eQwCJGiQNXH0I5vxglJq54wQhSxSagJvHly2GwbhEg++jfLlaQImaB
	ZUwS0zafYwVJCAkESEyY+4UZxOYUCJbY1t0F1MDBISwQIbF0tTdImEVAVWL9rhlgm3kFbCUu
	vZnPDmELSvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmkDESAuoSj/7qQpxgJNH5bhkjRImIxL4X
	7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4GTzTHoH
	46oGi0OMAhyMSjy8DhOLgoRYE8uKK3MPMUpwMCuJ8GotBwrxpiRWVqUW5ccXleakFh9iTAZ6
	dCKzlGhyPjAR5pXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QD
	o8jC3QYbYk4aX5A1k9LcrJ7LeCrqo8SqxxdWZhxz/VB0suRVBOd89e0JkekNxYJL369yV1+e
	8Se3PXWXq1pnY1vQw/rkhY0GTnn1CmpZqwMtvJuPzO/N76xjiakQn7Jm1vu5ta58L9hZH0pd
	6+s+rtG9/ISgwILu2qTHvTsud+xwvMczOXSaEktxRqKhFnNRcSIAPZnmDnoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 01, 2013 9:16 AM, Wei Yongjun wrote:
> 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.

Commit message is right? :-(

Best regards,
Jingoo Han

> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/mtd/nand/omap2.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
> index ec40b8d..f777250 100644
> --- a/drivers/mtd/nand/omap2.c
> +++ b/drivers/mtd/nand/omap2.c
> @@ -1953,7 +1953,8 @@ static int omap_nand_probe(struct platform_device *pdev)
>  		nand_chip->ecc.read_page	= omap_read_page_bch;
>  		nand_chip->ecc.write_page	= omap_write_page_bch;
>  		/* This ECC scheme requires ELM H/W block */
> -		if (is_elm_present(info, pdata->elm_of_node, BCH8_ECC) < 0) {
> +		err = is_elm_present(info, pdata->elm_of_node, BCH8_ECC);
> +		if (err < 0) {
>  			pr_err("nand: error: could not initialize ELM\n");
>  			goto return_error;
>  		}

