Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaAGX7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:59:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:32404 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaAGX66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:58:58 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-1a-52cc94ba90b7
Sun-Java-System-SMTP-Warning: Lines longer than SMTP allows found and wrapped.
From: Jingoo Han <jg1.han@samsung.com>
To: "'Wei Yongjun'" <weiyj.lk@gmail.com>,
        "'Brian Norris'" <computersforpeace@gmail.com>
Cc: "'Wan ZongShun'" <mcuos.com@gmail.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <CAPgLHd_RMOPLP2f4nA1vqNNddocMUX7f-gE29TTkuJZPUm=SWw@mail.gmail.com>
In-reply-to: <CAPgLHd_RMOPLP2f4nA1vqNNddocMUX7f-gE29TTkuJZPUm=SWw@mail.gmail.com>
Subject: Re: [PATCH -next] mtd: nuc900_nand: remove redundant return value
 check of platform_get_resource()
Date: Wed, 08 Jan 2014 08:58:49 +0900
Message-id: <001401cf0c04$691d63d0$3b582b70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8LrcRwF1EIwsMtR9+BqUwW+BotEQAVlnQQ
Content-language: ko
x-cr-hashedpuzzle: Duir FOs6 I018 KSVu Xmuq cT96 pU8H 9HRw AAEvHw== AAPcwA==
 AAjU1Q== ADGc7A== ADWhSQ== AIT2eg== AI1zbQ==
 ALuFig==;9;YwBvAG0AcAB1AHQAZQByAHMAZgBvAHIAcABlAGEAYwBlAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBkAHcAbQB3ADIAQABpAG4AZgByAGEAZABlAGEAZAAuAG8AcgBnADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGEAcgBtAC0AawBlAHIAbgBlAGwAQABsAGkAcwB0AHMALgBpAG4AZgByAGEAZABlAGEAZAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAG0AdABkAEAAbABpAHMAdABzAC4AaQBuAGYAcgBhAGQAZQBhAGQALgBvAHIAZwA7AG0AYwB1AG8AcwAuAGMAbwBtAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwB3AGUAaQB5AGoALgBsAGsAQABnAG0AYQBpAGwALgBjAG8AbQA7AHkAbwBuAGcAagB1AG4AXwB3AGUAaQBAAHQAcgBlAG4AZABtAGkAYwByAG8ALgBjAG8AbQAuAGMAbgA=;Sosha1_v1;7;{B00519A9-82E4-4BBB-B5FA-53CA92C9C344};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Tue,
 07 Jan 2014 23:58:32
 GMT;UgBlADoAIABbAFAAQQBUAEMASAAgAC0AbgBlAHgAdABdACAAbQB0AGQAOgAgAG4AdQBjADkAMAAwAF8AbgBhAG4AZAA6ACAAcgBlAG0AbwB2AGUAIAByAGUAZAB1AG4AZAB
	hAG4AdAAgAHIAZQB0AHUAcgBuACAAdgBhAGwAdQBlACAAYwBoAGUAYwBrACAAbwBmACAAcABsAGEAdABmAG8AcgBtAF8AZwBlAHQAXwByAGUAcwBvAHUAcgBjAGUAKAApAA==
x-cr-puzzleid: {B00519A9-82E4-4BBB-B5FA-53CA92C9C344}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t8zfd1dU84EGTy/zm5x5MJaZouJKycz
	W1xeeInVYtPja6wWl3fNYbPY3bSM3eLp9DqLD5eOMlvsXNfJ7sDpsXPWXXaPzSu0PDYvqffo
	27KK0WPpvaOMHp83yQWwRXHZpKTmZJalFunbJXBlbLjUxFSwkKPizIn7bA2Mr9m6GDk5JARM
	JCYsXM0KYYtJXLi3HijOxSEksIxRYv6bN3BFf/d8ZIZITGeU2P9vGwuE84tRYuLrl8wgVcIC
	fhJNcyaB2WwCahJfvhxmB7FFBMIknrW9YAKxmQX+MkpM6K4HsYUEAiTOb/7JAmJzCgRLnFr4
	G2pOrsSLc8vB6lkEVCV2rGlhBLF5BWwlzt/azQphC0r8mHyPBWKmlsT6nceh5stLbF7zFmgO
	B9DV6hKP/upCnGAkcefmN6hyEYl9L94xgtwvIdDNKfGpaSMLRL2pxKttgRDxuRwS/z/uYYG4
	QUDi2+RDUDWyEpsOMEMCRVLi4IobLBMYpWchuWgWkotmIbloFpLVCxhZVjGKphYkFxQnpRcZ
	6hUn5haX5qXrJefnbmKEpIfeHYy3D1gfYkwGWj+RWUo0OR+YXvJK4g2NzYwsTE1MjY3MLc1I
	E1YS5016mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXHOgj/MWy9e/GYTtPm+3aHV7/Xj
	/VlWzHjjlJAkkCV0sPXznxZz5QVfRBZtmfCByWWzpmG4tOWMa95Z/3wNpmo5TZhe0r+k5FlF
	5LE/57fa8bQ6+uY2dD2UCYj9+H7S/Hl3eipdwr9PSD3xrpBR5Ki59nyGR3XvMvTfTJov4vlY
	XHR3dPuy8NtKLMUZiYZazEXFiQB9leZMJQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsVy+t9jQd1dU84EGVx7yGRx5MJaZouJKycz
	W1xeeInVYtPja6wWl3fNYbPY3bSM3eLp9DqLD5eOMlvsXNfJ7sDpsXPWXXaPzSu0PDYvqffo
	27KK0WPpvaOMHp83yQWwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl
	5qbaKrn4BOi6ZeYA3aSkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNhw
	qYmpYCFHxZkT99kaGF+zdTFyckgImEj83fORGcIWk7hwbz1QnItDSGA6o8T+f9tYIJxfjBIT
	X78EqxIW8JNomjMJzGYTUJP48uUwO4gtIhAm8aztBROIzSzwl1FiQnc9iC0kECBxfvNPFhCb
	UyBY4tTC31BzciVenFsOVs8ioCqxY00LI4jNK2Arcf7WblYIW1Dix+R7LBAztSTW7zwONV9e
	YvOat0BzOICuVpd49FcX4gQjiTs3v0GVi0jse/GOEeR+CYFuTolPTRtZIOpNJV5tC5zAKDoL
	yYZZSDbMQrJhFpJRCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEJ59n0jsYVzVYHGIU
	4GBU4uG9oXYmSIg1say4MvcQowQHs5II77FuoBBvSmJlVWpRfnxRaU5q8SHGZGAATGSWEk3O
	BybGvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgnMHKp5dw
	Z8X8Oat7ehZavplqrDnf7n9qh/IW+8A3cXseJixez3VM0iEm59PUtmlRmgm+W/WXan2If3C0
	3NdafElU3pK9nc0hydsN/odNq5X5xf9611cNvVQe++qlDlbeh5ZUvNdljOV/+SBz3ow0t/Vz
	lmzdx7R54d+0XUu+afLE5B3SLDv3X4mlOCPRUIu5qDgRADuTcLiCAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 07, 2014 10:39 PM, Wei Yongjun wrote:
> 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove unneeded error handling on the result of a call
> to platform_get_resource() when the value is passed to
> devm_ioremap_resource().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/mtd/nand/nuc900_nand.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/mtd/nand/nuc900_nand.c b/drivers/mtd/nand/nuc900_nand.c
> index 661fd14..9ee09a8 100644
> --- a/drivers/mtd/nand/nuc900_nand.c
> +++ b/drivers/mtd/nand/nuc900_nand.c
> @@ -268,9 +268,6 @@ static int nuc900_nand_probe(struct platform_device *pdev)
>  	chip->ecc.mode		= NAND_ECC_SOFT;
> 
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res)
> -		return -ENXIO;
> -
>  	nuc900_nand->reg = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(nuc900_nand->reg))
>  		return PTR_ERR(nuc900_nand->reg);

