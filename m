Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3AXCmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 21:42:14 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:26948 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab3AXCmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 21:42:04 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-39-51009f7a7c25
Message-id: <51009F6D.5040001@samsung.com>
Date: Thu, 24 Jan 2013 11:41:49 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Dongjin Kim <tobetter@gmail.com>
Cc: "unlisted-recipients: ;Chris Ball" <cjb@laptop.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Will Newton <will.newton@imgtec.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: dw_mmc: Add MSHC compatible for Exynos4412
References: <1358954692-5625-1-git-send-email-tobetter@gmail.com>
In-reply-to: <1358954692-5625-1-git-send-email-tobetter@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zPd2q+QyBBnOfC1pc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLWr7nMWjCTo2LjvVMsDYy32boYOTkkBEwk9vW/ZoGw
	xSQu3FsPFOfiEBJYxigxf8psuKKvH/6wQCQWMUp0vPrNCuG8ZJQ4sbqPCaSKV0BL4uzWqWAd
	LAKqEs3Hm1hBbDYBHYnt346D1YgKhEmsnH6FBaJeUOLH5HtgtoiAikTX0adMIEOZBZ4ySjzd
	MwWsWVjARWLVtw/sILaQgKPE86mzGEFsTgEniTu/toINZQZasL91GhuELS+xec1bZpBBEgLd
	7BIftz1igbhIQOLb5ENANgdQQlZi0wFmiNckJQ6uuMEygVFsFpKbZiEZOwvJ2AWMzKsYRVML
	kguKk9JzDfWKE3OLS/PS9ZLzczcxQiJEagfjygaLQ4wCHIxKPLwKqgyBQqyJZcWVuYcYJTiY
	lUR41eqBQrwpiZVVqUX58UWlOanFhxiTgQ6cyCwlmpwPjN68knhDYwNjQ0NLQzNTS1MD0oSV
	xHkZTz0JEBJITyxJzU5NLUgtgtnCxMEp1cDo/PJvR8q+G6sO7d3ic7WH03Shv8b+lQuirldy
	aJf1mj9b1OHFwlV3XqRf1Jdt3r8djO1P14pfkUipu/Vmr+2ElKTuh2dbp7j+e8u5V/zB0l2N
	/yKm+X8W4RWq5Kxk2nfA+thTnRNWhyRfs1kIq7o3Xa2NWidhc2+ytePSmSn/M4oc+jg3HZmj
	xFKckWioxVxUnAgAtu0D6NQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t9jAd2q+QyBBlvncFpc3jWHzeLI/35G
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz1q+5zFowk6Ni
	471TLA2Mt9m6GDk5JARMJL5++MMCYYtJXLi3HijOxSEksIhRouPVb1YI5yWjxInVfUwgVbwC
	WhJnt04F62YRUJVoPt7ECmKzCehIbP92HKxGVCBMYuX0KywQ9YISPybfA7NFBFQkuo4+ZQIZ
	yizwlFHi6Z4pYM3CAi4Sq759YAexhQQcJZ5PncUIYnMKOEnc+bUVbCgz0IL9rdPYIGx5ic1r
	3jJPYBSYhWTHLCRls5CULWBkXsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHH/PpHYwrmyw
	OMQowMGoxMOroMoQKMSaWFZcmXuIUYKDWUmEV60eKMSbklhZlVqUH19UmpNafIgxGRgEE5ml
	RJPzgakhryTe0NjEzMjSyMzYxNzYmDRhJXFexlNPAoQE0hNLUrNTUwtSi2C2MHFwSjUwWu9b
	duyPRoQkw17eRa91DxdeS9rDr84pVHdpQlKQVt1X2XuluzV4Iled8luZvCbuSsSl+Dv7frsL
	POzjd1xaFC2eZ3Wn30HxQhTffe1j/7SltzvbmK3r1d61pvea/BOZIye0m+Zn8DQndi6/smd2
	brxS5fXWH7OmzmHsZ7o/y6e2hDmIsfK1EktxRqKhFnNRcSIAobrTagMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 12:24 AM, Dongjin Kim wrote:
> This patch adds the compatible string for MSHC controller of Exynos4412, and
> reuse the controller specific properties with Exynos5250 since those have same
> features.
> 
> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> ---
>  drivers/mmc/host/dw_mmc-exynos.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
> index 0cb9bcb..4f7685f 100644
> --- a/drivers/mmc/host/dw_mmc-exynos.c
> +++ b/drivers/mmc/host/dw_mmc-exynos.c
> @@ -204,6 +204,8 @@ static const struct dw_mci_drv_data exynos5250_drv_data = {
>  };
>  
>  static const struct of_device_id dw_mci_exynos_match[] = {
> +	{ .compatible = "samsung,exynos4412-dw-mshc",
> +			.data = &exynos5250_drv_data, },
If we can use the same drv_data, should be changed to more generic name, not "exynos5250_".

Best Regards,
Jaehoon Chung
>  	{ .compatible = "samsung,exynos5250-dw-mshc",
>  			.data = &exynos5250_drv_data, },
>  	{},
> 

