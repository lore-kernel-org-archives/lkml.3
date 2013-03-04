Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab3CDM5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:57:42 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:32454 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab3CDM5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:57:40 -0500
X-AuditID: cbfee690-b7f6b6d000004563-eb-51349a426fe9
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Cesar Eduardo Barros'" <cesarb@cesarb.net>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Joe Perches'" <joe@perches.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
 <1362275632-20242-4-git-send-email-cesarb@cesarb.net>
In-reply-to: <1362275632-20242-4-git-send-email-cesarb@cesarb.net>
Subject: RE: [PATCH 03/14] MAINTAINERS: remove arch/arm/plat-s3c24xx/
Date: Mon, 04 Mar 2013 21:57:38 +0900
Message-id: <007f01ce18d7$d94ab430$8be01c90$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4XsgSnxLrcOUWaS1Oy2Iv5BMrB2wBJbwbA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zY12nWSaBBn/WyFvMWb+GzWLSugNM
	FrOuBVnMvv+YxWLT42usFpd3zWGzmHF+H5PF5g8v2Rw4PFqae9g8jtyewezxd9ULZo8TM36z
	eGxeUu/xZdU1Zo/Pm+QC2KO4bFJSczLLUov07RK4MhoXPmAqeMFecf3GPrYGxp1sXYycHBIC
	JhKXr65khbDFJC7cWw8U5+IQEljGKDF7fgsTTNGnqz+ZIRLTGSXeL30CVfWXUeLiwtfMIFVs
	AhoSh98/YwexRQRiJa7evsMOUsQs8JBRonn/XbCEkEClxLqJf1lAbE4BJ4kvT/6A2cICrhIv
	HjSD3cQioCqxaN9ksNW8ArYSr7rWsELYghI/Jt8Dq2cW0JJYv/M4E4QtL7F5zVugIziATlWX
	ePRXF+IGI4llS2awQZSISOx78Y4R5B4JgUYOiY3HNzBC7BKQ+Db5EAtEr6zEpgPMEB9LShxc
	cYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKJXnJhbXJqXrpecn7uJERLbE3Yw
	3jtgfYgxGWj9RGYp0eR8YGrIK4k3NDY2MTMxNTG3NDU3JU1YSZxX/pJMoJBAemJJanZqakFq
	UXxRaU5q8SFGJg5OqQbGZm3m22ET1tlulX0irlAsJdud5baekd+k8Pjfj2dtRFg21IeF6/tM
	sb7dsbm5JLr41NeHoZdYjGXXRn3eyuuwyzqE55FPd8B26d3Jn1YsVOJvPbMtpDb8pbfzlmdK
	Npc92afMtQv7lq9XffF2brFV6JXJaz6YmS6o4bvCV6zZbNSwv3+pRpsSS3FGoqEWc1FxIgBr
	kglOAwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsVy+t9jQV2nWSaBBq1HpCzmrF/DZjFp3QEm
	i1nXgixm33/MYrHp8TVWi8u75rBZzDi/j8li84eXbA4cHi3NPWweR27PYPb4u+oFs8eJGb9Z
	PDYvqff4suoas8fnTXIB7FENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5
	ibmptkouPgG6bpk5QEcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDMa
	Fz5gKnjBXnH9xj62BsadbF2MnBwSAiYSn67+ZIawxSQu3FsPFOfiEBKYzijxfukTKOcvo8TF
	ha/BqtgENCQOv3/GDmKLCMRKXL19hx2kiFngIaNE8/67YAkhgUqJdRP/soDYnAJOEl+e/AGz
	hQVcJV48aAZbzSKgKrFo32QmEJtXwFbiVdcaVghbUOLH5Htg9cwCWhLrdx5ngrDlJTaveQt0
	BAfQqeoSj/7qQtxgJLFsyQw2iBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXF
	Sem5RnrFibnFpXnpesn5uZsYwYnjmfQOxlUNFocYBTgYlXh4BT4ZBwqxJpYVV+YeYpTgYFYS
	4Y1IMAkU4k1JrKxKLcqPLyrNSS0+xJgM9OhEZinR5HxgUssriTc0NjEzsjQyszAyMTcnTVhJ
	nJfx1JMAIYH0xJLU7NTUgtQimC1MHJxSDYyuD/wFTG+uEM1tTdhhuCe/eMuCF1/OlXZctBQR
	FtT9yXFn67tmNsOn+eefhhZt/Fw2R2JrCq/5rDUetziz+b61setP493OnSxg51QT5urKuWZ1
	1WbF3B36HlvO8qzY8PdGokRho7oza/Rdg1XpqnUbJjlPOzFVfcvM068c2mfUb7Zcen9XDo8S
	S3FGoqEWc1FxIgDipZYyYAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cesar Eduardo Barros wrote:
> 
> This directory was removed by commit 09ec1d7 (ARM: S3C24XX: Remove
> plat-s3c24xx directory in arch/arm/).
> 
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

- Kukjin

> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3c074d5..5af82f9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1119,7 +1119,6 @@ L:	linux-samsung-soc@vger.kernel.org (moderated
> for non-subscribers)
>  W:	http://www.fluff.org/ben/linux/
>  S:	Maintained
>  F:	arch/arm/plat-samsung/
> -F:	arch/arm/plat-s3c24xx/
>  F:	arch/arm/mach-s3c24*/
>  F:	arch/arm/mach-s3c64xx/
>  F:	drivers/*/*s3c2410*
> --
> 1.7.11.7

