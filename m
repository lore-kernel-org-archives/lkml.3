Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaIYBFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 21:05:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39540 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaIYBFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 21:05:10 -0400
X-AuditID: cbfee68d-f79296d000004278-98-54236a449fe8
Message-id: <54236A44.2050904@samsung.com>
Date: Thu, 25 Sep 2014 10:05:08 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, subhransu.s.prusty@intel.com,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 03/27] extcon: arizona: use
 pm_runtime_last_busy_and_autosuspend helper
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
 <1411575342-31048-4-git-send-email-vinod.koul@intel.com>
In-reply-to: <1411575342-31048-4-git-send-email-vinod.koul@intel.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWyRsSkRNclSznE4OQEM4vLu+awWdxuXMFm
	sfztfzaLNVtXMFq87NvP4sDqsXjPSyaPlxN/s3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJX
	xvqjN9gLlnBWbH76gqmB8TJ7FyMnh4SAicSB61+ZIGwxiQv31rN1MXJxCAksZZSYs7GfFaZo
	5pZtUInpjBIvtm1mgXBeM0psWTSJBaSKV0BL4vyGFYwgNouAqsTeY0fAVrABxfe/uMEGYosK
	hEmsnH4Fql5Q4sfke2C2CFD9lp8dYL3MAn2MEt+mKYDYwgKxEvfbFoBdISRQLzF9xWGwUzkF
	XCUO9Xxig6jXkdjfOg3KlpfYvOYtM8TV69glzt0LhLhHQOLb5ENAuziA4rISmw5AlUhKHFxx
	g2UCo9gsJBfNQjJ1FpKpCxiZVzGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmIERtbpf896dzDe
	PmB9iFGAg1GJh/eDj3KIEGtiWXFl7iFGU6ArJjJLiSbnA+M3ryTe0NjMyMLUxNTYyNzSTEmc
	V1HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxon7Dn1sZ403s/iW8/xlsojYl/uG/A84
	Z9qflD/l1fmrqrLjVJmL54ybbUf5VhQYxjjI9OdeeT/lr+0+vUxH/516/6tPezMI+k99/OTp
	pQeZ2SeFDir8X7fNUjh2P7eKT//zR3ue9M3wna+q2inff2CripjHJOfce3yh0i+fVcyIUtDc
	f2J6tRJLcUaioRZzUXEiAMU4LP2nAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jQV2XLOUQg/4b+haXd81hs7jduILN
	Yvnb/2wWa7auYLR42befxYHVY/Gel0weLyf+ZvPo27KK0ePzJrkAlqgGRpuM1MSU1CKF1Lzk
	/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoMVKCmWJOaVAoYDE4mIlfTtM
	E0JD3HQtYBojdH1DguB6jAzQQMIaxoz1R2+wFyzhrNj89AVTA+Nl9i5GTg4JAROJmVu2sUHY
	YhIX7q0Hsrk4hASmM0q82LaZBcJ5zSixZdEkFpAqXgEtifMbVjCC2CwCqhJ7jx0Bm8QGFN//
	4gbYJFGBMImV069A1QtK/Jh8D8wWAarf8rMDrJdZoI9R4ts0BRBbWCBW4n7bAlYQW0igXmL6
	isNMIDangKvEoZ5PbBD1OhL7W6dB2fISm9e8ZZ7AKDALyYpZSMpmISlbwMi8ilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4cp9J7WBc2WBxiFGAg1GJh9fDXzlEiDWxrLgy9xCjBAezkgiv
	hgNQiDclsbIqtSg/vqg0J7X4EKMpMAQmMkuJJucDk0peSbyhsYmZkaWRuaGFkbG5kjjvgVbr
	QCGB9MSS1OzU1ILUIpg+Jg5OqQZG1b8yjQ4z1ykVnvj5p/RjGOsyy5KLK/uN9jw7uNI6YpeM
	pUKlvsy3mHvpcvcjTcIazk+Z6fnJQLWVa9FxFkEpZ/M/M87aCJW9Zu6/NudvyL3vIaICux7n
	30qb3L85MtHihozPHO9S80g3u545l45Jm1jYOh9V07s7cfp2b7d/3t3vzi29c7RRiaU4I9FQ
	i7moOBEADi2gq/ICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 01:14 AM, Vinod Koul wrote:
> Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
> coding the same code
> 
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> ---
>  drivers/extcon/extcon-arizona.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index ba51588..7774e80 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -323,8 +323,7 @@ static void arizona_stop_mic(struct arizona_extcon_info *info)
>  
>  	if (change) {
>  		regulator_disable(info->micvdd);
> -		pm_runtime_mark_last_busy(info->dev);
> -		pm_runtime_put_autosuspend(info->dev);
> +		pm_runtime_last_busy_and_autosuspend(info->dev);
>  	}
>  }
>  
> @@ -1077,8 +1076,7 @@ out:
>  
>  	mutex_unlock(&info->lock);
>  
> -	pm_runtime_mark_last_busy(info->dev);
> -	pm_runtime_put_autosuspend(info->dev);
> +	pm_runtime_last_busy_and_autosuspend(info->dev);
>  
>  	return IRQ_HANDLED;
>  }
> 

Looks good to me about this patch.

Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi

