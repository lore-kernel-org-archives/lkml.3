Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab3ENAj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 20:39:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:65091 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3ENAj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:39:27 -0400
X-AuditID: cbfee68e-b7f276d000002279-67-519187bdd540
From: Jingoo Han <jg1.han@samsung.com>
To: "'Laurent Navet'" <laurent.navet@gmail.com>, nico@fluxnic.net,
        cjb@laptop.org
Cc: andrew@lunn.ch, thomas.petazzoni@free-electrons.com, jason@lakedaemon.net,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
References: <1368369860-32085-1-git-send-email-laurent.navet@gmail.com>
In-reply-to: <1368369860-32085-1-git-send-email-laurent.navet@gmail.com>
Subject: Re: [PATCH] drivers: mmc: host: use devm_ioremap_resource()
Date: Tue, 14 May 2013 09:39:25 +0900
Message-id: <001601ce503b$7bfd1840$73f748c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGa9h0TvmcQNByFJ8FdRzkk/aiUkJlqihdQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+Zvu7e9omBBj/7NS3O3z3EbLH99UY2
	i8Yll1ksLi+8xGrR2Hqb2eLyrjlsFkf+9zNazHvxgs3i5J9eRounD5qYHLg8np1oZ/N4suki
	o8fOWXfZPRoOnGfxOHRlLaPHnWt72Dx27vjM5NG3ZRWjx+dNcgGcUVw2Kak5mWWpRfp2CVwZ
	hw68YC74wlFx83ofYwPjbPYuRk4OCQETiVWXPjBD2GISF+6tZ+ti5OIQEljGKHHm3n+4orWP
	Z7JDJKYzSlx9f4cZwvnFKLG/qY0NpIpNQE3iy5fDYB0iAv4Sm7qOM4IUMQtcYZSYvaGPCSQh
	JOAusb39Jdg+TgEPiQvXW1m7GDk4hAVcJK5f1wMJswioSvzq2sUKYvMKWErc7XjMDmELSvyY
	fI8FxGYW0JJYv/M4E4QtL7F5zVuoFxQkdpx9zQhxg5HEwZ2vWSFqRCT2vXgHdo+EwEIOiY7m
	X2wQywQkvk0+xAJyg4SArMSmA1BzJCUOrrjBMoFRYhaS1bOQrJ6FZPUsJCsWMLKsYhRNLUgu
	KE5KLzLSK07MLS7NS9dLzs/dxAhJA307GG8esD7EmAy0fiKzlGhyPjCN5JXEGxqbGVmYmpga
	G5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUbVY9hljs5Awe0bGCfNZ
	Z1peG2qfe9j438vvSu+6x5L6ql9N7EInH7t0aX/y0Y0Cu/r4Xr3alFz2e52j/voHUdvEn9pl
	Fs8PXMWtNrX7crLm9tjD96abna2U4upU/W0jyr9PP0Zu4azdTutWx+q32dRe7ijZF55z3//R
	4cXrvx1+WbVBZPWHQiWW4oxEQy3mouJEALf1f2QZAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jQd297RMDDRqXq1icv3uI2WL7641s
	Fo1LLrNYXF54idWisfU2s8XlXXPYLI7872e0mPfiBZvFyT+9jBZPHzQxOXB5PDvRzubxZNNF
	Ro+ds+6yezQcOM/icejKWkaPO9f2sHns3PGZyaNvyypGj8+b5AI4oxoYbTJSE1NSixRS85Lz
	UzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOATlVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZhw68IK54AtHxc3rfYwNjLPZuxg5OSQETCTWPp4JZYtJ
	XLi3nq2LkYtDSGA6o8TV93eYIZxfjBL7m9rYQKrYBNQkvnw5DNYhIuAvsanrOCNIEbPAFUaJ
	2Rv6mEASQgLuEtvbXzKD2JwCHhIXrreydjFycAgLuEhcv64HEmYRUJX41bWLFcTmFbCUuNvx
	mB3CFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zBCXKkjsOPuaEeIGI4mDO1+zQtSISOx78Y5x
	AqPQLCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4yz6R2MK5s
	sDjEKMDBqMTD21A3MVCINbGsuDL3EKMEB7OSCO9+XqAQb0piZVVqUX58UWlOavEhxmSgTycy
	S4km5wMTYF5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MDbt
	rCvXPGfbo18ZwvM6fnfO1JQ6nbRZzKxchjx109wyZ/PIbO9TmszstFP59NZUvmqec4l28oYx
	p/mit09MWSv1QTZq4TaHbZIchvf27Q88JRznWix7wuiTVPZXqf/bVSbtbGL6a3ZBJjjoTPgO
	w6CSHf6LbmycnCXKEt+afZjNpsT+pmyGEktxRqKhFnNRcSIAMLlrJnYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sunday, May 12, 2013 11:44 PM, Laurent Navet wrote:
> 
> eplace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.

CC'ed Sachin Kamat

Fix the typo: eplace -> replace

> 
> Found with coccicheck and this semantic patch:
>  scripts/coccinelle/api/devm_ioremap_resource.cocci
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>

It looks good.
Reviewed-by: Jingoo Han <jg1.han@samsung.com>

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

