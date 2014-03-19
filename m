Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbaCSATV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:19:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60807 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaCSATT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:19:19 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-01-5328e285669e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Fengguang Wu'" <fengguang.wu@intel.com>
References: <002e01cf3290$ccda9430$668fbc90$%han@samsung.com>
 <002f01cf3291$02c7f7e0$0857e7a0$%han@samsung.com>
In-reply-to: <002f01cf3291$02c7f7e0$0857e7a0$%han@samsung.com>
Subject: Re: [PATCH 2/3] regulator: dbx500: use seq_puts() instead of
 seq_printf()
Date: Wed, 19 Mar 2014 09:19:17 +0900
Message-id: <001301cf4308$dd78baf0$986a30d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8ykMzEt0AEx/NVROGPrQsXYu79GwAABOiQBB3kj4A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t8zY93WRxrBBnuuy1qsf3CMyWLqwyds
	Fu+fr2e2uLzwEqvFtysdTBaXd81hc2Dz2DnrLrvH4j0vmTw2repk8+jbsorR4/vSNewenzfJ
	BbBFcdmkpOZklqUW6dslcGX83sVZMJ+/YvnrRuYGxnU8XYycHBICJhI7jjSzQNhiEhfurWfr
	YuTiEBJYxijx78VCNpiiLR3NrBCJRYwS9za3sUA4vxklGrvPM4JUsQmoSXz5cpi9i5GDQ0RA
	VeL/K3eQGmaBU4wSs59uZQWpERIolLi44BwziM0pYCcx9dAvsNXCAiES+zd8B7NZgHrPT13B
	DmLzCthK/Jh5iAXCFpT4MfkemM0soCWxfudxJghbXmLzmrfMIHslBNQlHv3VhTjBSmLPxnCI
	ChGJfS/eMUL88pZd4tBeUYhNAhLfJoNMB+mUldh0gBmiRFLi4IobLBMYJWYh2TsLyd5ZSPbO
	QrJhASPLKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQyJ24g/H+AetDjMlA6ycyS4km5wMj
	P68k3tDYzMjC1MTU2Mjc0ow0YSVx3vRHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGPnm
	vw5c9O04U5LrxzvFF7ZlfjoQeP8UB7/cu+0vVryW/VzEJlClutu7Wseev/BwmXOU3uf9pzav
	Ct/6NdaeKeRr/xrJuu+T6xkfnBXs0hRYyCX6mVtecOmM+SYl4V8+7esKeKEutW1vTn5gdH3E
	6SPavGoMgeu0rI6uDT71ctWbZkcPT66/O5VYijMSDbWYi4oTAb1XBmTyAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jAd3WRxrBBiePS1qsf3CMyWLqwyds
	Fu+fr2e2uLzwEqvFtysdTBaXd81hc2Dz2DnrLrvH4j0vmTw2repk8+jbsorR4/vSNewenzfJ
	BbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM+L2Ls2A+f8Xy143MDYzr
	eLoYOTkkBEwktnQ0s0LYYhIX7q1n62Lk4hASWMQocW9zGwuE85tRorH7PCNIFZuAmsSXL4fZ
	uxg5OEQEVCX+v3IHqWEWOMUoMfvpVrBJQgKFEhcXnGMGsTkF7CSmHvrFAmILC4RI7N/wHcxm
	Aeo9P3UFO4jNK2Ar8WPmIRYIW1Dix+R7YDazgJbE+p3HmSBseYnNa94yg+yVEFCXePRXF+IE
	K4k9G8MhKkQk9r14xziBUWgWkkGzkAyahWTQLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXr
	JefnbmIEJ4ZnUjsYVzZYHGIU4GBU4uE9EKURLMSaWFZcmXuIUYKDWUmEV/guUIg3JbGyKrUo
	P76oNCe1+BBjMtCfE5mlRJPzgUkrryTe0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC6Yklqdmp
	qQWpRTBbmDg4pRoYj23snzmzWPJw3yOHu2d2v5shoZbw/4b5tBCL7au+7zv18L7jAqGLnxUi
	+FzFJzKHGAZJmha+Duv8k1icPXfvC0GZedFnts0wjNw9z/X/7OdG2f3/7z851uDu7fe0YOnp
	yq9KT0MLZny+LJpY/Fti596vH/r3i/nWnQ25J+f+3Fpu2TRBPcG/2kosxRmJhlrMRcWJAAHr
	xRJQAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 26, 2014 10:21 AM, Jingoo Han wrote:
> 
> For a constant format without additional arguments, use seq_puts()
> instead of seq_printf(). Also, it fixes the following checkpatch
> warning.
> 
>   WARNING: Prefer seq_puts to seq_printf
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/regulator/dbx500-prcmu.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/regulator/dbx500-prcmu.c b/drivers/regulator/dbx500-prcmu.c
> index f111dfb..3dd1096 100644
> --- a/drivers/regulator/dbx500-prcmu.c
> +++ b/drivers/regulator/dbx500-prcmu.c
> @@ -97,10 +97,10 @@ static int ux500_regulator_power_state_cnt_print(struct seq_file *s, void *p)
>  	int err;
> 
>  	/* print power state count */
> -	err = seq_printf(s, "ux500-regulator power state count: %i\n",
> -		power_state_active_get());
> +	err = seq_puts(s, "ux500-regulator power state count: %i\n",
> +			power_state_active_get());

It makes build error with 'make ARCH=arm allmodconfig', as 
Fengguang Wu reported.

  drivers/regulator/dbx500-prcmu.c: In function 'ux500_regulator_power_state_cnt_print':
  drivers/regulator/dbx500-prcmu.c:103:4: error: too many arguments to function 'seq_puts'

So, I will send v2 patch. Sorry for annoying you.
Thank you.

Best regards,
Jingoo Han

>  	if (err < 0)
> -		dev_err(dev, "seq_printf overflow\n");
> +		dev_err(dev, "seq_puts overflow\n");
> 
>  	return 0;
>  }
> @@ -127,9 +127,9 @@ static int ux500_regulator_status_print(struct seq_file *s, void *p)
>  	int i;
> 
>  	/* print dump header */
> -	err = seq_printf(s, "ux500-regulator status:\n");
> +	err = seq_puts(s, "ux500-regulator status:\n");
>  	if (err < 0)
> -		dev_err(dev, "seq_printf overflow\n");
> +		dev_err(dev, "seq_puts overflow\n");
> 
>  	err = seq_printf(s, "%31s : %8s : %8s\n", "current",
>  		"before", "after");
> --
> 1.7.10.4


