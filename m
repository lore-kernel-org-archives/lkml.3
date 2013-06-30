Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab3F3Xvu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 19:51:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14944 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3F3Xvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 19:51:49 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f6f6d00000740c-6a-51d0c4930466
Content-transfer-encoding: 8BIT
Message-id: <51D0C490.6090804@samsung.com>
Date: Mon, 01 Jul 2013 08:51:44 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Myungjoo Ham <myungjoo.ham@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: max77693: Fix trivial typo
References: <1372477049.9121.0.camel@phoenix>
In-reply-to: <1372477049.9121.0.camel@phoenix>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsWyRsSkSHfykQuBBocnS1ocmfOV2WLqwyds
	Ft+udDBZXN41h83iduMKNgdWj52z7rJ7tP0s89i0qpPNo2/LKkaPz5vkAlijuGxSUnMyy1KL
	9O0SuDLuve9nLZjDXnGrbR5rA+Mr1i5GDg4JAROJY6fUuhg5gUwxiQv31rN1MXJxCAksZZR4
	d/o5O0TCROL1qUlMEIlFjBJf/zWxgiR4BQQlfky+xwIyiFlAXuLIpWyQMLOAusSkeYuYIepf
	MkocmnYUql5LYtqnu0wgNouAqkT7g41gcTYBOYm3Td8YQWxRgTCJqxOOs4DYIgJKEqvuX2YB
	GcQsMJFRYvfXmWBXCwtYSWybaAdSIySgK9F0eS8biM0poCfR//ASWL2EwDF2ids7PzJDLBOQ
	+Db5EAvEx7ISmw4wQzwmKXFwxQ2WCYxis5C8MwvhnVlI3lnAyLyKUTS1ILmgOCm9yESvODG3
	uDQvXS85P3cTIzC6Tv97NmEH470D1ocYk4E2TmSWEk3OB0ZnXkm8obGZkYWpiamxkbmlGWnC
	SuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYDTVyfeftr34Tq/Ngf0lx6dFjbB1X
	rE39QvJWum2rLxTOrhLcIGhZ+qVp9tHIRYxvz/Bqtku8Cq+0u8LtLOhonhfMznekUrBHrpRt
	nXGBT/nWqHq2iChHS7G1cjo2RZrx5Ww5Jl1Hry6496+lufa5dN3+x9unF32yWRfxnbONP0yf
	bdN5RyWW4oxEQy3mouJEAK+etYvEAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgO7kIxcCDVbtF7Q4Mucrs8XUh0/Y
	LL5d6WCyuLxrDpvF7cYVbA6sHjtn3WX3aPtZ5rFpVSebR9+WVYwenzfJBbBGNTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
	K+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm3Hvfz1owh73iVts81gbGV6xdjJwcEgImEq9P
	TWKCsMUkLtxbz9bFyMUhJLCIUeLrvyawIl4BQYkfk++xdDFycDALyEscuZQNEmYWUJeYNG8R
	M0T9S0aJQ9OOQtVrSUz7dBdsKIuAqkT7g41gcTYBOYm3Td8YQWxRgTCJqxOOs4DYIgJKEqvu
	X2YBGcQsMJFRYvfXmawgy4QFrCS2TbQDqRES0JVouryXDcTmFNCT6H94iWUCo8AsJOfNQjhv
	FpLzFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIjt5n0jsYVzVYHGIU4GBU4uFdMP1C
	oBBrYllxZe4hRgkOZiUR3u2fzwcK8aYkVlalFuXHF5XmpBYfYkwGem4is5Rocj4wseSVxBsa
	m5gZWRqZG1oYGZuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+OcO4qez3541kf081ix
	lB1SOpLh4SE+fcpUv/br1WGnrOt/nzVomi3DcGndHOOJ3lG1r/YItSYGzfoQfHONyusjZxki
	1W2/JyclHV7AJBCa0/XvcHGAXXDo5VaXXuZ1zC6/9bm3vPb0PbTa+MKWoy/WMc+8+FbbIyM4
	YK9gxlq56AZW/Wm2+kosxRmJhlrMRcWJAF9Wpb4iAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 06월 29일 12:37, Axel Lin wrote:

> Fix trivial typo in the equation to check upper bound of current setting.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/max77693.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
> index 674ece7..d45a4dd 100644
> --- a/drivers/regulator/max77693.c
> +++ b/drivers/regulator/max77693.c
> @@ -97,7 +97,7 @@ static int max77693_chg_set_current_limit(struct regulator_dev *rdev,
>  	while (chg_min_uA + CHGIN_ILIM_STEP_20mA * sel < min_uA)
>  		sel++;
>  
> -	if (chg_min_uA * CHGIN_ILIM_STEP_20mA * sel > max_uA)
> +	if (chg_min_uA + CHGIN_ILIM_STEP_20mA * sel > max_uA)
>  		return -EINVAL;
>  
>  	/* the first four codes for charger current are all 60mA */


Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>


Thanks,
Jonghwa

