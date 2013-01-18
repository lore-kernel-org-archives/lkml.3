Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3ARD55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:57:57 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28896 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3ARD5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:57:55 -0500
X-AuditID: cbfee61b-b7f616d00000319b-36-50f8c8416faf
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Cong Ding'" <dinggnu@gmail.com>, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358185860-5425-1-git-send-email-dinggnu@gmail.com>
In-reply-to: <1358185860-5425-1-git-send-email-dinggnu@gmail.com>
Subject: RE: [PATCH] arm: mach-s3c24xx/common.c: fix uninitialized variable
 warning
Date: Thu, 17 Jan 2013 19:57:39 -0800
Message-id: <00bf01cdf52f$f7c7d8f0$e7578ad0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJYHS6Gyah3p2AQ9B5r9vFdZGBkPJc6JW1Q
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zfV3HEz8CDPYuMLW4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mp4NOUme0EDW8Xcd7cZGxjvsHQxcnJICJhInNrexwhh
	i0lcuLeerYuRi0NIYBmjxMNPU9lhig49f8wCkVjEKLFs1QtWCOcvo8TuWS/YQKrYBDQkDr9/
	xg6SEBG4xSjxeOMTsB1CAg4SCz+vYwKxOQUcJU4uPcwMYgsLhEq0PmtkBbFZBFQlHp85BFbP
	K2Ap8fjNbEYIW1Dix+R7YHFmAS2JzduaWCFseYnNa94yQ5ynILHj7Gugeg6gxUYS7w7aQZSI
	S0x68JAdYryAxLfJIOM5gMplJTYdYAY5U0JgHrvEi51LWSHGSEocXHGDZQKj+Cwkm2ch2TwL
	yeZZSFYsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREST9I7GFc1WBxiFOBgVOLh3ajy
	I0CINbGsuDL3EKMEB7OSCG/rQaAQb0piZVVqUX58UWlOavEhRh+gyycyS4km5wNjPa8k3tDY
	2MTMxNTE3NLU3BSHsJI4L+OpJwFCAumJJanZqakFqUUw45g4OKUaGOPX279dZV8ukV8WFsPT
	LrnpySnXw9fqp35WacyfZ/7ah43nHafZrr9Wp/xu660O31HSE6tRwr8ia8GKM2HO1yaWJuv+
	bzY6Js9mbnTiQ8qajMVLm1M2L1thccS4Q+NBzpIAu/DMvoADc7YUb24P1Qj2DPxQKXjk4Mnd
	TJXupr82vF6ymlF8qxJLcUaioRZzUXEiAK+a6j3UAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t9jAV3HEz8CDP5cNbC4vGsOm8WM8/uY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMeDTlJntBA1vF
	3He3GRsY77B0MXJySAiYSBx6/hjKFpO4cG89WxcjF4eQwCJGiWWrXrBCOH8ZJXbPesEGUsUm
	oCFx+P0zdpCEiMAtRonHG5+AtQsJOEgs/LyOCcTmFHCUOLn0MDOILSwQKtH6rJEVxGYRUJV4
	fOYQWD2vgKXE4zezGSFsQYkfk++BxZkFtCQ2b2tihbDlJTavecsMcZ6CxI6zr4HqOYAWG0m8
	O2gHUSIuMenBQ/YJjIKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/
	dxMjOFqfSe9gXNVgcYhRgINRiYd3o8qPACHWxLLiytxDjBIczEoivK0HgUK8KYmVValF+fFF
	pTmpxYcYfYAencgsJZqcD0wkeSXxhsYmZkaWRmYWRibm5jiElcR5GU89CRASSE8sSc1OTS1I
	LYIZx8TBKdXAWC+7/n/Rne6o85LXPmp3PDmZzBBe3pSxViNv/w5z2703FRaaLnv2/MYKv4n2
	cTItnhxmGqYGx9f+d9rh85w7I3u2SxKvV81aDTFFtvQDQQ2rbTeInv9o5iprs/JZL7P/g6yb
	aZc2V0X8ecdlJupqeUH96acFonmr3y0oWblLxbCKMXaWGQeHEktxRqKhFnNRcSIAg9ljEQMD	AAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Ding wrote:
> 
> the use of variable tmp is uninitialized, so we fix it.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  arch/arm/mach-s3c24xx/common.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-s3c24xx/common.c b/arch/arm/mach-
> s3c24xx/common.c
> index 0c9e9a7..6bcf87f 100644
> --- a/arch/arm/mach-s3c24xx/common.c
> +++ b/arch/arm/mach-s3c24xx/common.c
> @@ -197,7 +197,7 @@ static unsigned long s3c24xx_read_idcode_v4(void)
> 
>  static void s3c24xx_default_idle(void)
>  {
> -	unsigned long tmp;
> +	unsigned long tmp = 0;
>  	int i;
> 
>  	/* idle the system by using the idle mode which will wait for an
> --
> 1.7.9.5

Yes, correct. Applied.

Thanks.

- Kukjin

