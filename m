Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111AbaKYBCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:02:48 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:45190 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaKYBCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:02:45 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-fc-5473d5336da2
Message-id: <5473D532.10206@samsung.com>
Date: Tue, 25 Nov 2014 10:02:42 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>, Dan Murphy <dmurphy@ti.com>,
        Hyunhee Kim <hyunhee.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ARM: dts: Add regulator-haptic device node for
 exynos3250-rinato
References: <1416840651-17141-1-git-send-email-jaewon02.kim@samsung.com>
 <1416840651-17141-3-git-send-email-jaewon02.kim@samsung.com>
In-reply-to: <1416840651-17141-3-git-send-email-jaewon02.kim@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWyRsSkQNf4anGIwYIPQhaHF71gtOg+vYXV
	4vOHFnaLHQ1HWC16F1xls7j56RurxeVdc9gsZpzfx2SxaOsXdgdOj52z7rJ79G1Zxehx/MZ2
	Jo/Pm+QCWKK4bFJSczLLUov07RK4Mq5v/sFacJOtYv+aK2wNjGtZuxg5OSQETCR2n1/GCGGL
	SVy4t56ti5GLQ0hgKaNEx9n/jDBF6xsfMkEkpjNKNM7pZYVwXjNKvNzygLmLkYODV0BD4sRN
	DZAGFgFViQdNj8A2sAloSex/cYMNxBYVCJNYOf0KC4jNKyAo8WPyPTBbREBT4siRI4wgM5kF
	9jBJvFq1kx0kISwQJ/Fm5hEWiGXtjBL7eu6BTeUU8JTYNOcF2HnMAjoS+1unsUHY8hKb17xl
	BmmQELjFLvFtxQZGiJMEJL5NPsQCcqmEgKzEpgPMEK9JShxccYNlAqPYLCRHzUIydhaSsQsY
	mVcxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBEbh6X/PJuxgvHfA+hCjAAejEg9vx9niECHW
	xLLiytxDjKZAV0xklhJNzgfGel5JvKGxmZGFqYmpsZG5pZmSOO9rqZ/BQgLpiSWp2ampBalF
	8UWlOanFhxiZODilGhh5fiZc2TJ3evqeTcJMecrhTHMybrCH3g/44WOmLeRufqFvd4Z8oVBS
	7TcJgb0ro3aKXNrUKGHxp8r/bfiW37Zt/qo7+ZZduMXybH2meIBW9Zeziya47H198vZ+7fll
	Z6RFNr9dNjWKVb37Z+gHxtW1csqO0dKMdsc0C8SCJ4fveS9tUsV7MV2JpTgj0VCLuag4EQB4
	9atYvQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQV3jq8UhBm8Pc1scXvSC0aL79BZW
	i88fWtgtdjQcYbXoXXCVzeLmp2+sFpd3zWGzmHF+H5PFoq1f2B04PXbOusvu0bdlFaPH8Rvb
	mTw+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hxffMP1oKbbBX7
	11xha2Bcy9rFyMkhIWAisb7xIROELSZx4d56ti5GLg4hgemMEo1zelkhnNeMEi+3PGDuYuTg
	4BXQkDhxUwOkgUVAVeJB0yOwQWwCWhL7X9xgA7FFBcIkVk6/wgJi8woISvyYfA/MFhHQlDhy
	5AgjyExmgT1MEq9W7WQHSQgLxEm8mXmEBWJZO6PEvp57YFM5BTwlNs15wQhiMwvoSOxvncYG
	YctLbF7zlnkCo8AsJEtmISmbhaRsASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgGH8m
	tYNxZYPFIUYBDkYlHt6Os8UhQqyJZcWVuYcYJTiYlUR4o+YBhXhTEiurUovy44tKc1KLDzGa
	AsNgIrOUaHI+MP3klcQbGpuYGVkamRtaGBmbK4nz3riZGyIkkJ5YkpqdmlqQWgTTx8TBKdXA
	qGigcb3wsvAJ++NnJk/Q//H4UWnMkZqVn57WdLtrVHJ3+8rN5nS+9PVDTPbNn7cyffzrjqfz
	BmmGZVa17lV4/Pzny+39iqkXbx1TruaIfKHxJqlSQND31/W4K7z+K2uflO/KbdA7PjnlRP+7
	ZoaNO45Pv/bOR7bzeXegb5mUyDG/TZpN3ayTlViKMxINtZiLihMBq4TEEwcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 11:50 PM, Jaewon Kim wrote:
> This patch adds regulator-haptic device node controlled by regulator.
> 
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> ---
>  arch/arm/boot/dts/exynos3250-rinato.dts |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
> index 84380fa..da03005 100644
> --- a/arch/arm/boot/dts/exynos3250-rinato.dts
> +++ b/arch/arm/boot/dts/exynos3250-rinato.dts
> @@ -104,6 +104,13 @@
>  			};
>  		};
>  	};
> +
> +	haptics {
> +		compatible = "regulator-haptic";
> +		haptic-supply = <&motor_reg>;
> +		min-microvolt = <1100000>;
> +		max-microvolt = <2700000>;
> +	};
>  };
>  
>  &adc {
> 

Looks good to me.

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi
