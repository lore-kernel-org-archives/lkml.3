Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaKSLYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:24:36 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58544 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaKSLYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:24:34 -0500
X-AuditID: cbfee691-f79b86d000004a5a-fa-546c7def331f
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Vikas Sajjan'" <vikas.sajjan@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1908469.QaqIJlesoD@amdc1032>
In-reply-to: <1908469.QaqIJlesoD@amdc1032>
Subject: RE: [PATCH v4] ARM: EXYNOS: add Exynos3250 PMU support
Date: Wed, 19 Nov 2014 16:54:10 +0530
Message-id: <000a01d003eb$79fe9630$6dfbc290$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ5eE2JiUcqFiQsZiQBdg6gRon+6ZsU5H9g
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkVvd9bU6IwdYnZhYbZ6xntbj+5Tmr
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyWLXrD6PFzWfbmRw4PXbOusvusXlJvUffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBlXPj4haXgAXvFhBPP2BsY57B1MXJySAiYSHReXwtli0lc
	uLcezBYSWMoocf1BHUzN1u6nQHEuoPgiRomNE6YxQjh/GSVeXrsJ1sEmoCvx5P1cZhBbRCBJ
	4s/M3WAdzAIzmCSe/Z3GDDFWU2LnnRfsIDangJbE9LsnwJqFBewldq64CxTn4GARUJV4dKEM
	JMwrYClxf99tVghbUOLH5HssIDYzUOv6nceZIGx5ic1r3jJDXKogsePsa0aIG4wken9uZoao
	EZeY9OAhO8g9EgIf2SWu7eoCG8QiICDxbfIhFpC9EgKyEpsOQM2RlDi44gbLBEaJWUhWz0Ky
	ehaS1bOQrFjAyLKKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cTIzCOT/97NnEH4/0D1ocYBTgY
	lXh4X77NDhFiTSwrrsw9xGgKdNFEZinR5HxgssgriTc0NjOyMDUxNTYytzRTEufVkf4ZLCSQ
	nliSmp2aWpBaFF9UmpNafIiRiYNTqoGxx84/PvtT67eoDx/d7TfVbux8pHz4Zpf/BZPKlVkx
	Cy0uKEnMm7Chs03j3ofYpumLbjRcWha9Tk24LTVV9v2K4zuybgSYrImxX3PisIa5pwNn/dON
	F329+b1dj5UerGCUqn4ubs1/fEG7XrBLudM+w/vMsybmsTwq8p11hDn8+5peIQZFjsVKLMUZ
	iYZazEXFiQCgHaqu3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAd2XtTkhBntmsVlsnLGe1eL6l+es
	Fr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/JYtWuP4wWN59tZ3Lg9Ng56y67x+Yl9R59W1Yx
	enzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6Dr
	lpkDdIuSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePCxy8sBQ/YKyac
	eMbewDiHrYuRk0NCwERia/dTKFtM4sK99UA2F4eQwCJGiY0TpjFCOH8ZJV5euwlWxSagK/Hk
	/VxmEFtEIEniz8zdYB3MAjOYJJ79nQaWEBLQlNh55wU7iM0poCUx/e4JsGZhAXuJnSvuAsU5
	OFgEVCUeXSgDCfMKWErc33ebFcIWlPgx+R4LiM0M1Lp+53EmCFteYvOat8wQlypI7Dj7mhHi
	BiOJ3p+bmSFqxCUmPXjIPoFRaBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfm
	pesl5+duYgSniWdSOxhXNlgcYhTgYFTi4X3xNjtEiDWxrLgy9xCjBAezkgjv1eqcECHelMTK
	qtSi/Pii0pzU4kOMpkCPTmSWEk3OB6awvJJ4Q2MTc1NjU0sTCxMzSyVx3gOt1oFCAumJJanZ
	qakFqUUwfUwcnFINjNzJUZpHSt0vWb80v6N36tzzybcfFYfNFSm9bvq+db+v6oTTFxxFPj0o
	v/b1eNHStus7FnIGXvm4J+bn5IImse9Xez7cnXrwCov9+pPTZ/Abqz19//bG3xMJO1wjPtz6
	FpBZ+yJL/2fDx2Dvl9zcfVlTAgONjqqetKjn0/qadvrLu8uB8dEr1ixRYinOSDTUYi4qTgQA
	QyonqCkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 18, 2014 11:05 PM, Bartlomiej Zolnierkiewicz Wrote:
> This patch prepares the PMU code for the future:
> - suspend/resume (S2R) support
> - cpuidle AFTR/W-AFTR modes support
> on Exynos3250.
> 
> Cc: Pankaj Dubey <pankaj.dubey@samsung.com>
> Cc: Vikas Sajjan <vikas.sajjan@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Other than one small nitpick patch looks fine to me. Tested on Exynos3250
based
Espresso board and kernel booted fine.

Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>

> 
> +static void exynos3250_pmu_init(void)
> +{
> +	unsigned int value;
> +
> +	/*
> +	 * To prevent form issuing new bus request form L2 memory system

typo: %s/form/from

> +	 * If core status is power down, should be set '1' to L2 power down
> +	 */

Thanks,
Pankaj Dubey

> --
> 1.8.2.3


