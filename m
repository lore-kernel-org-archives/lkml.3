Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaH1EZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 00:25:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:62538 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaH1EZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 00:25:16 -0400
X-AuditID: cbfee691-f79546d0000011a1-54-53feaf2a6ef4
Message-id: <53FEAF2A.1080400@samsung.com>
Date: Thu, 28 Aug 2014 13:25:14 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com,
        kgene.kim@samsung.com, ch.naveen@samsung.com,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eduardo Valentin <edubezval@gmail.com>
Subject: Re: [PATCHv5 4/4] thermal: exynos: Remove duplicate code when reading
 triminfo register of Exynos5440
References: <1409016665-3824-1-git-send-email-cw00.choi@samsung.com>
 <1409016665-3824-5-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1409016665-3824-5-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsWyRsSkSFdr/b9ggzWvVCwaroZYbJyxntXi
	7vPDjBbXvzxntViz/yeTxfwr11gtehdcZbM42/SG3WLTYyD38q45bBafe48wWsw4v4/J4snD
	PjYHXo+ds+6yeyze85LJY/OSeo++LasYPY7f2M7k8XmTXABbFJdNSmpOZllqkb5dAlfGt64n
	bAV/uCv2zfZvYLzE2cXIySEhYCLx5vJ/FghbTOLCvfVsXYxcHEICSxklZizfxdjFyAFW9KGd
	HSK+iFHi5L4ZzCANQgKvGSX2rwdr5hXQkrh4diU7iM0ioCrRe/ECK4jNBhTf/+IGG4gtKhAm
	sXL6Fah6QYkfk++B2SICGhIz/15hBFnALHCXSWLnyjmMIAlhgQKJFc/aGCGW1UssmnkDbDGn
	gKvEtecvwZYxC+hI7G+dxgZhy0tsXvOWGWSQhMBfdolv558wQVwkIPFt8iEWiG9kJTYdYIb4
	WFLi4IobLBMYxWYhuWkWkrGzkIxdwMi8ilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMwbk//
	ezZxB+P9A9aHGAU4GJV4eGck/AsWYk0sK67MPcRoCnTFRGYp0eR8YHLIK4k3NDYzsjA1MTU2
	Mrc0UxLn1ZH+GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUZenpvDe4fcVc7z83s5Yp3k3
	wOr2h7dVsg1znuxN5w65aC4/c0Y0s9XO3ZP/1rWn7bwuxBx5M4SrVGnWEb7ECbbLp87xW9Gz
	uqZgdpaf8r6qsgw3+Usnrhl8XJ+UtmrZ3FqTKMvpR9PnnRRZN8n0RsKC3cVHJYLKQos8e0Ou
	c57+rXOfR8HykhJLcUaioRZzUXEiAJcbAbnWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgK7W+n/BBr3bZS0aroZYbJyxntXi
	7vPDjBbXvzxntViz/yeTxfwr11gtehdcZbM42/SG3WLTYyD38q45bBafe48wWsw4v4/J4snD
	PjYHXo+ds+6yeyze85LJY/OSeo++LasYPY7f2M7k8XmTXABbVAOjTUZqYkpqkUJqXnJ+SmZe
	uq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QoUoKZYk5pUChgMTiYiV9O0wTQkPc
	dC1gGiN0fUOC4HqMDNBAwhrGjG9dT9gK/nBX7Jvt38B4ibOLkYNDQsBE4kM7excjJ5ApJnHh
	3nq2LkYuDiGBRYwSJ/fNYAZJCAm8ZpTYv54FxOYV0JK4eHYlWAOLgKpE78ULrCA2G1B8/4sb
	bCC2qECYxMrpV6DqBSV+TL4HZosIaEjM/HuFEWQBs8BdJomdK+cwgiSEBQokVjxrY4RYVi+x
	aOYNsMWcAq4S156/BFvGLKAjsb91GhuELS+xec1b5gmMArOQ7JiFpGwWkrIFjMyrGEVTC5IL
	ipPScw31ihNzi0vz0vWS83M3MYKTwjOpHYwrGywOMQpwMCrx8DrE/QsWYk0sK67MPcQowcGs
	JMKbDhLiTUmsrEotyo8vKs1JLT7EaAoMgonMUqLJ+cCElVcSb2hsYmZkaWRuaGFkbK4kznug
	1TpQSCA9sSQ1OzW1ILUIpo+Jg1OqgZH1q2Drwht6sV+umbrXaz3033lm990Pv3naX66STVGb
	rLf9yMwDf/aXGqtctmaZ9fS+TP+yr1N75BvfJgq+8VKXa/LOrTR9JSmv8U7FKmmO+IZn+mxR
	66xVzY8sPcDU9id/+uTXrteSzdZ9ZWTMinv6Y8PR7xLb+bd/ifuivUPg3TWbP9dNVG4rsRRn
	JBpqMRcVJwIAzBCNlSADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Eduardo,

This patch is wrong. It is my mistake.

Please ignore only this patch because
the offset calculation of 'case 0' is different from 'case 2'.

Best Regards,
Chanwoo Choi

On 08/26/2014 10:31 AM, Chanwoo Choi wrote:
> This patch remove simply duplicate code when reading triminfo register of Exynos5440.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index 64c702a..5888467 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -187,15 +187,13 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
>  		 */
>  		switch (data->id) {
>  		case 0:
> +		case 2:
>  			trim_info = readl(data->base +
>  			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
>  			break;
>  		case 1:
>  			trim_info = readl(data->base + reg->triminfo_data);
>  			break;
> -		case 2:
> -			trim_info = readl(data->base -
> -			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
>  		}
>  	} else {
>  		/* On exynos5420 the triminfo register is in the shared space */
> 

