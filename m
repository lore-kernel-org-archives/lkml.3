Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab3FDD67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 23:58:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27792 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab3FDD65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 23:58:57 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
X-AuditID: cbfee690-b7f6f6d00000740c-e4-51ad65fd7c01
Content-transfer-encoding: 8BIT
Message-id: <51AD660F.7060508@samsung.com>
Date: Tue, 04 Jun 2013 12:59:11 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Olof Johansson <olof@lixom.net>, John Stultz <john.stultz@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 05/10] mmc: dw_mmc-pltfm: remove static from
 dw_mci_pltfm_remove
References: <201306030055.15413.heiko@sntech.de>
 <201306030058.27184.heiko@sntech.de>
In-reply-to: <201306030058.27184.heiko@sntech.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSpPs3dW2gwdqPyhZ/Jx1jt9j+eiOb
	xYHZD1ktDvzZwWjx/9FrVosbv9pYLc781rWY8mc5k8Wmx9dYLS7vmsNmceR/P6PF7cu8Fk8n
	XGSzOHX9M5vF4RUHmCw+3L/IbLF501RmB0GPluYeNo/fvyYxeiz4fIXd49CVtYwed67tYfN4
	d+4cu8fmJfUe52csZPS4cqKJ1aNvyypGj+3X5jF7fN4kF8ATxWWTkpqTWZZapG+XwJWx/2I7
	S8E3too7/XcYGxifsHYxcnJICJhI7Ng9C8oWk7hwbz1bFyMXh5DAUkaJKxd7WGCKWlbch0os
	YpR4Of0tO0iCV0BQ4sfke0BFHBzMAvISRy5lg4SZBXQk9rdOg6p/ySixbMY9Roh6LYkV+54x
	gtSzCKhKTDukABJmA6rf/u04E4gtKhAmsamnGcwWETCTuHW1jRlkDrPAYlaJVW/a2UASwkBF
	V0++ApsjJBAusXqJCojJKWAo8euiPUi5hMAZDomrC76D3c8iICDxbfIhsDMlBGQlNh1ghnhL
	UuLgihssExjFZiF5ZhbCM7OQPLOAkXkVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmBSOP3v
	2YQdjPcOWB9iTAbaOJFZSjQ5H5hU8kriDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1O
	TS1ILYovKs1JLT7EyMTBKdXAaPHQt29mSsxsYSbrXWqrD+grtNfqr9+8tOfTsz3vNoidve0s
	ebVO2VP9qtNMkQxvT5UjZQ6lH87amNszR3a4np9qxNGqtLffU3vjBy6vNPnCh0sTzgjfUcrP
	uD15RWMtp+W5I0v0ND0Dk3YJafaesNcq2Pe/9UPCXoXFBwoumlyO2+Sbt+WzEktxRqKhFnNR
	cSIAVgjCESADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t9jAd2/qWsDDRZulrL4O+kYu8X21xvZ
	LA7MfshqceDPDkaL/49es1rc+NXGanHmt67FlD/LmSw2Pb7GanF51xw2iyP/+xktbl/mtXg6
	4SKbxanrn9ksDq84wGTx4f5FZovNm6YyOwh6tDT3sHn8/jWJ0WPB5yvsHoeurGX0uHNtD5vH
	u3Pn2D02L6n3OD9jIaPHlRNNrB59W1Yxemy/No/Z4/MmuQCeqAZGm4zUxJTUIoXUvOT8lMy8
	dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygz5QUyhJzSoFCAYnFxUr6dpgmhIa4
	6VrANEbo+oYEwfUYGaCBhDWMGfsvtrMUfGOruNN/h7GB8QlrFyMnh4SAiUTLivtsELaYxIV7
	64FsLg4hgUWMEi+nv2UHSfAKCEr8mHyPpYuRg4NZQF7iyKVskDCzgI7E/tZpUPUvGSWWzbjH
	CFGvJbFi3zNGkHoWAVWJaYcUQMJsQPXbvx1nArFFBcIkNvU0g9kiAmYSt662MYPMYRZYzCqx
	6k072EHCQEVXT74CmyMkEC6xeokKiMkpYCjx66L9BEaBWUiOm4Vw3Cwkxy1gZF7FKJpakFxQ
	nJSea6hXnJhbXJqXrpecn7uJEZxynkntYFzZYHGIUYCDUYmHt2LbmkAh1sSy4srcQ4wSHMxK
	Iry9LmsDhXhTEiurUovy44tKc1KLDzEmA702kVlKNDkfmA7zSuINjU3MjCyNzA0tjIzNSRNW
	Euc90GodKCSQnliSmp2aWpBaBLOFiYNTqoGRf/La6jbblBoliXUX1qfyxV675bHjz0+TU68S
	sh4uaL8eKe/q992vaALfa7dvxorqXZFm0ceME68+mWEeeZfXb5/KoqX8rX2X39Tef7O/edLa
	kDXxroqJDqfcdv963xBQbd3mrDt36mafe3ufzTr40ap3Y/N86wIBZuZJBtuN3q+cxrHa8Zmw
	EktxRqKhFnNRcSIA4U/Ky30DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

On 06/03/2013 07:58 AM, Heiko Stübner wrote:
> dw_mci_pltfm_remove gets exported and used by dw_mmc-exynos, so should
> not be static.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  drivers/mmc/host/dw_mmc-pltfm.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
> index 37873f1..0048da8 100644
> --- a/drivers/mmc/host/dw_mmc-pltfm.c
> +++ b/drivers/mmc/host/dw_mmc-pltfm.c
> @@ -68,7 +68,7 @@ static int dw_mci_pltfm_probe(struct platform_device *pdev)
>  	return dw_mci_pltfm_register(pdev, NULL);
>  }
>  
> -static int dw_mci_pltfm_remove(struct platform_device *pdev)
> +int dw_mci_pltfm_remove(struct platform_device *pdev)
>  {
>  	struct dw_mci *host = platform_get_drvdata(pdev);
>  
> 

