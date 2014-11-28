Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaK1NfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:35:21 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16456 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaK1NfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:35:14 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-49-54787a105753
Content-transfer-encoding: 8BIT
Message-id: <1417181710.18249.28.camel@AMDC1943>
Subject: Re: [PATCH] power: max14577: Remove SYSFS dependency from Kconfig
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Karol Wrona <k.wrona@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Fri, 28 Nov 2014 14:35:10 +0100
In-reply-to: <1417180982-15127-1-git-send-email-k.wrona@samsung.com>
References: <1417180982-15127-1-git-send-email-k.wrona@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xK7oCVRUhBu8m21hsnLGe1eLUsv1M
	Fmeb3rBbXN41h83ic+8RRovTu0sc2Dw2repk8+jbsorR4/MmuQDmKC6blNSczLLUIn27BK6M
	htdmBX/YKrouXWJsYDzJ2sXIySEhYCJxfNFNJghbTOLCvfVsXYxcHEICSxklft5aCJbgFRCU
	+DH5HksXIwcHs4C8xJFL2SBhZgF1iUnzFjFD1H9mlJjzZA8rRL2BxKwJMxhBbGEBL4lTZ36x
	gNhsAsYSm5cvYQOxRQRUJY59mAm2jFngKKNEx+4NzCAJFqDE7HVrwAZxCrhIfLi9AewIIQFn
	ib09F5lAjpAQUJZo7HebwCgwC8l5sxDOm4XkvAWMzKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLz
	czcxQgL46w7GpcesDjEKcDAq8fBOsKwIEWJNLCuuzD3EKMHBrCTCm14CFOJNSaysSi3Kjy8q
	zUktPsTIxMEp1cDY1TkhPV10ifIf6VVf79+8wWJQpm23Yfkxn1lWV1acLp7WZL4kkMdSaoKR
	t6JDeYqV6Xq9pae/aN7sm1tlk162cPnrt++W5t3WXfAwePrzQxUXyueoCph3yaVdOrnV7F+9
	kutM/0vHFYW7f4TLOfdcMn+1pGv7I/3TRfsjp6xdW/W+hCcm5tF8JZbijERDLeai4kQAfplJ
	MT4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-11-28 at 14:23 +0100, Karol Wrona wrote:
> This is only a small clean-up. The driver can be built without SYSFS
> as there exist stubs for used functions.
> 
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> ---
>  drivers/power/Kconfig |    1 -
>  1 file changed, 1 deletion(-)

Seems fine to me.
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof

> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 0108c2a..69fa8a9 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -327,7 +327,6 @@ config CHARGER_MANAGER
>  config CHARGER_MAX14577
>  	tristate "Maxim MAX14577/77836 battery charger driver"
>  	depends on MFD_MAX14577
> -	depends on SYSFS
>  	help
>  	  Say Y to enable support for the battery charger control sysfs and
>  	  platform data of MAX14577/77836 MUICs.

