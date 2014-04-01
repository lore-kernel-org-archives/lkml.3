Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaDABSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 21:18:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64243 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaDABSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 21:18:49 -0400
X-AuditID: cbfee68e-b7f566d000002344-7b-533a13f7f6a5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Tejun Heo'" <tj@kernel.org>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-ide@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <6050762.sdUI3gZZlK@amdc1032>
In-reply-to: <6050762.sdUI3gZZlK@amdc1032>
Subject: Re: [PATCH] pata_samsung_cf: fix ata_host_activate() failure handling
Date: Tue, 01 Apr 2014 10:18:46 +0900
Message-id: <000801cf4d48$54c45210$fe4cf630$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9NCihonFDChBLSQVyTFf1J7WNi4wAPfwgg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zfd3vwlbBBj1bZS02zljPajFp3QEm
	i8sLL7Fa9C64ymax6fE1VotjOx4BxXbNYbOYcX4fk8Wv5UcZHTg9/q56weyxaVUnm8fmJfUe
	fVtWMXp83iQXwBrFZZOSmpNZllqkb5fAlXHn/lGWgtWcFa/WXGJqYLzI3sXIySEhYCJxfedL
	RghbTOLCvfVsXYxcHEICyxglvm44yQZT1PfgPQtEYjqjxOwPH1khnN+MEncuHwJrZxNQk/jy
	5TDYWBGBSInfc+aBdTALfGeU+N//jBkkISSgKXFxx1SmLkYODk4BLYnT/w1BwsICfhLvn19l
	AQmzCKhKbH/qBhLmFbCVWDC/gw3CFpT4MfkeC4jNDNS5fudxJghbXmLzmrfMIK0SAuoSj/7q
	gpgiAkYSnxewQVSISOx78Y4R5BgJgb/sEmd3QCRYBAQkvk0+xALRKiux6QAzxLuSEgdX3GCZ
	wCgxC8niWUgWz0KyeBaSFQsYWVYxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525ihERz3w7Gmwes
	DzEmA62fyCwlmpwPTAZ5JfGGxmZGFqYmpsZG5pZmpAkrifMuepgUJCSQnliSmp2aWpBaFF9U
	mpNafIiRiYNTqoGxUmmbkfuhNw81nnTcs1rot2Rqa7+g8cwzz0O2ZZz1vc1xOmPlubmHeE88
	+2l4/+RsteYz7w7d4s59I/1dmVNd7DRL2Z6/fytOs3Z9PfJisUfDxt0rZyxJVPU+3irC0/du
	k4PWjUWn4rcfTMg89YHzyqXln1ZM/lkmFKQftUwx9s406YPl28/d26LEUpyRaKjFXFScCAAb
	jSby/AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t9jQd3vwlbBBjseS1hsnLGe1WLSugNM
	FpcXXmK16F1wlc1i0+NrrBbHdjwCiu2aw2Yx4/w+Jotfy48yOnB6/F31gtlj06pONo/NS+o9
	+rasYvT4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+ggJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGnftHWQpW
	c1a8WnOJqYHxInsXIyeHhICJRN+D9ywQtpjEhXvr2boYuTiEBKYzSsz+8JEVwvnNKHHn8iFG
	kCo2ATWJL18Og3WLCERK/J4zjwWkiFngO6PE//5nzCAJIQFNiYs7pjJ1MXJwcApoSZz+bwgS
	Fhbwk3j//CoLSJhFQFVi+1M3kDCvgK3EgvkdbBC2oMSPyffADmIG6ly/8zgThC0vsXnNW2aQ
	VgkBdYlHf3VBTBEBI4nPC9ggKkQk9r14xziBUWgWkkGzkAyahWTQLCQtCxhZVjGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIEp4pn0jsYVzVYHGIU4GBU4uG1KLcMFmJNLCuuzD3EKMHBrCTC
	e+Q9UIg3JbGyKrUoP76oNCe1+BBjMtCbE5mlRJPzgWksryTe0NjEzMjSyMzCyMTcnDRhJXHe
	g63WgUIC6YklqdmpqQWpRTBbmDg4pRoY3dN9JfdzLPefyzPBaK1DVOGH6QvYRdd7zeaMit1+
	7y5j8K9li35lbf1eueeKcvjC0A22M1orKyOEJ7gYqHLnv691ceGT+RSmoRmz5dj9ecfqtiXY
	nhIwN2ha82p6BqdD3tsPMdbTTX994aiPviCi/vnYgsQHBro+b2vddZN+GXwrdTjRdUpaiaU4
	I9FQi7moOBEAl2krtFkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 01, 2014 2:53 AM, Tejun Heo wrote:
> 
> Add missing clk_disable() call to ata_host_activate() failure path.
> 
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/ata/pata_samsung_cf.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> Index: b/drivers/ata/pata_samsung_cf.c
> ===================================================================
> --- a/drivers/ata/pata_samsung_cf.c	2014-03-14 16:45:04.344724378 +0100
> +++ b/drivers/ata/pata_samsung_cf.c	2014-03-31 18:31:58.083631437 +0200
> @@ -594,9 +594,13 @@ static int __init pata_s3c_probe(struct
> 
>  	platform_set_drvdata(pdev, host);
> 
> -	return ata_host_activate(host, info->irq,
> -			info->irq ? pata_s3c_irq : NULL,
> -			0, &pata_s3c_sht);
> +	ret = ata_host_activate(host, info->irq,
> +				info->irq ? pata_s3c_irq : NULL,
> +				0, &pata_s3c_sht);
> +	if (ret)
> +		goto stop_clk;
> +
> +	return 0;
> 
>  stop_clk:
>  	clk_disable(info->clk);
> 
> --

