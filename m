Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3H2MF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 08:05:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48334 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab3H2MF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 08:05:57 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-03-521f391dec24
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Mischa Jonker'" <Mischa.Jonker@synopsys.com>,
        "'Chris Ball'" <cjb@laptop.org>, "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet.Gupta1@synopsys.com
References: <1377715229-2414-1-git-send-email-mjonker@synopsys.com>
In-reply-to: <1377715229-2414-1-git-send-email-mjonker@synopsys.com>
Subject: RE: [PATCH] mmc/dw_mmc: Add support for ARC
Date: Thu, 29 Aug 2013 21:05:49 +0900
Message-id: <001701cea4b0$19b00b10$4d102130$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6kHiNjfaWKfnCfTDCw/3UV1BQEwgAkUFHg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zQ11ZS/kgg8t3tSz+TjrGbrH99UY2
	i8u75rBZHPnfz2hx7sRHJovGV2uZHdg8fv+axOhx6MpaRo8t+z8zenzeJBfAEsVlk5Kak1mW
	WqRvl8CVceP0bNaCYxwVG3sSGhi/sHUxcnJICJhIvJm+kAnCFpO4cG89UJyLQ0hgGaPE/nM/
	2WGKXj6YygKRWMQo8fvCXlYI5w+jxJ+GA2BVbAJaEn/fvGEGSYgInGaUaP95CyjBAVTlLNH8
	WR+khlPAReL75WfMILYw0NTdm1axgtgsAqoS2ye+YgEp5xWwlej7mAIS5hUQlPgx+R4LiM0s
	YCDxflYfK4QtL7F5zVtmkHIJAXWJR391QcIiAkYSVz4cYYcoEZHY9+IdI8g1EgLX2CV+rvzL
	DrFKQOLb5EMsEL2yEpsOMEP8KClxcMUNlgmM4rOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFS
	epGhXnFibnFpXrpecn7uJkZIPPbuYLx9wPoQYzLQ+onMUqLJ+cB4ziuJNzQ2M7IwNTE1NjK3
	NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo+nszRfjW+W6+qrU2ZzenUst
	7ZVb9tCk9UNv9QIX/nsciR8bwg9mtkTnLBe+dcdF1fdc0IKPifO/XFkuHy3n+iVbuFpwu574
	HNadn8KrOIqc3mXn2YqrXWjovse2adrmhPTffz3v3v2s/ML3+V3N9vwDuxvSFn6eqjpj5r3f
	/u16eR3SOxbfV2Ipzkg01GIuKk4EAJWHiczdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV1ZS/kggwV71Sz+TjrGbrH99UY2
	i8u75rBZHPnfz2hx7sRHJovGV2uZHdg8fv+axOhx6MpaRo8t+z8zenzeJBfAEtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHHj9GzWgmMcFRt7EhoYv7B1MXJySAiYSLx8
	MJUFwhaTuHBvPVCci0NIYBGjxO8Le1khnD+MEn8aDrCDVLEJaEn8ffOGGSQhInCaUaL95y2g
	BAdQlbNE82d9kBpOAReJ75efMYPYwkAbdm9axQpiswioSmyf+IoFpJxXwFai72MKSJhXQFDi
	x+R7YEcwCxhIvJ/Vxwphy0tsXvOWGaRcQkBd4tFfXZCwiICRxJUPR9ghSkQk9r14xziBUXAW
	kkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER/sz6R2MqxosDjEK
	cDAq8fBG/JYNEmJNLCuuzD3EKMHBrCTC+5ZTPkiINyWxsiq1KD++qDQntfgQYzLQnxOZpUST
	84GJKK8k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGOU8W/Ic
	PTcfrol9EDbVJ+XnbIfJl09tPs89/aHj3RjZ4ItiaxS2yx2VeHlq7aKnf/ce3iDJElS869oZ
	84O3fqx7svfFEacZ0695TXt+Kf34dPWDlwXsmXJuzDy3ZHlLxM1nr40fqiuLPIqY7vFf50x9
	onGR+av+KRqbH64tDhdyvjl7dpX9MiNLJZbijERDLeai4kQAr+p6LDoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, August 29, 2013, Mischa Jonker wrote:
> Adapt Kconfig to include ARC in supported architectures
> 
> Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

Thanks,
Seungwon Jeon

> ---
>  drivers/mmc/host/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 8a4c066..6496d50 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -530,7 +530,7 @@ config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
> 
>  config MMC_DW
>  	tristate "Synopsys DesignWare Memory Card Interface"
> -	depends on ARM
> +	depends on ARC || ARM
>  	help
>  	  This selects support for the Synopsys DesignWare Mobile Storage IP
>  	  block, this provides host support for SD and MMC interfaces, in both
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

